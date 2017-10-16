- [CUDA syntax](http://www.icl.utk.edu/~mgates3/docs/cuda.html)
- [CUDA Occupancy Calculator](http://lxkarthi.github.io/cuda-calculator/)
- [CUDA compute-capability](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capabilities)
- [Cmake cuda](https://cmake.org/cmake/help/v3.0/module/FindCUDA.html)

# device code

```cpp
// This function is called by GPU and suppose to be executed on GPU
__device__ void func0(...){
  
}

// This function is called by CPU and __global__ with <<<dim3>>> arguments and suppose to be executed on GPU
__global__ void func1(...){
  func0()
}

// This function is called by CPU with <<<dim3>>> arguments and suppose to be executed on GPU
__host__ void func2(...){}

// entry point, run on CPU
int main(){
    func1<<<[g_x, g_y, g_z], [b_x,b_y,b_x]>>>(...)
    // func1<<<g_x, b_x>>>(...) equal func1<<<[g_x, 1, 1], [b_x, 1, 1]>>>(...)
    func2(...)
}


(a) __device__，表明声明的数据存放在显存中，所有的线程都可以访问，而且主机也可以通过运行时库访问；
(b) __shared__，表示数据存放在共享存储器中，只有在所在的块内的线程可以访问，其它块内的线程不能访问；
(c) __constant__，表明数据存放在常量存储器中，可以被所有的线程访问，也可以被主机通过运行时库访问；
(d) texture，表明其绑定的数据可以被纹理缓存加速存取，其实数据本身的存放位置并没有改变，纹理是来源于图形学的一介概念，CUDA 使用它的原因一部分在于支持图形处理，另一方面也可以利用它的一些特殊功能。

```

# CUDA 线程模型

- 硬件 SM = SP + warp scheduler，register，shared memory
    - SM：多个SP加上其他的一些资源组成一个streaming multiprocessor。也叫GPU大核
        - 其他资源如：warp scheduler，register，shared memory等。register和shared memory是SM的稀缺资源。
        - CUDA将这些资源分配给所有驻留在SM中的threads。这些有限的资源就使每个SM中active warps有非常严格的限制，也就限制了并行能力（但是相对CPU，GPU的register和shared memory还是要大很多。
    - SP：最基本的处理单元，streaming processor，也称为CUDA core。最后具体的指令和任务都是在SP上处理的。
- 软件抽象：
    - kernel调用的thread分四层
        - grid：`gridDim.x*gridDim.y*gridDim.z`个block构成grid
        - block：`blockDim.x*blockDim.y*blockDim.z`个thread组成一个block，同一个block中的threads可以同步，也可以通过shared memory通信
        - warp：`deviceProp.warpSize`个thread组成warp(目前是32), warp是GPU执行程序时的最小调度单位
        - thread：一个CUDA的程序的抽象
    - SIMT
        - 一个kernel内指令相同
        - 同在一个warp的线程，以不同数据资源执行相同的指令,这就是所谓 SIMT
        - thred分配
            - 一个SM可以运行多个block的thread
            - 同一个block中的threads必然在同一个SM中并行执行，如果block dim太大，会造成应用只跑在某个SM上, 分配好grid dim 和block dim，最大程度的利用硬件 
            - 一个SM可以同时运行多个warp，所有warp轮流进入SM, SM有较大register，上下文切换成本低
                - 根据Threads per block, Registers per thread, Shared memory per block 计算Active Threads per SM, Active Warps per Multiprocessor, Active Thread Blocks per Multiprocessor
                - `max_active_warp = min( SP / 32, AllRegisters/(32*RegistersPerThread)`
                - TODO `max_active_block = AllSharedMemory/SharedMemoryPerBlock`
    - nvida规定block和threa的坐标都是三维的，不过目前只使用二维坐标

# CUDA内存模型

- 硬件
    - 同一个SM内有内L1/texture Cache, shared memory
    - 整张卡有L2和global memory，就是硬件上看到的内存大小

- 软件：
    - cudaMalloc，cudaMemcpy，cudafree分配global memory，L1/texture Cache, shared memory也有相应函数来分配
    - 较新的GPU能够直接操作主存，也就是不用从主存拷贝数据到global memory再在GPU上处理
    - CUDA抽象出全局指针（主存和GPU memory），1+48位，增加的1位指示指针的内容位置【FYI 64位机只用48位指针】



五个内建变量，用于在运行时获得网格和块的尺寸及线程索引等信息

(a) gridDim, 一个包含三个元素 x, y, z 的结构体，表示网格在 x, y, z 三个方向上的尺寸，虽有三维，但目前只能使用二维；
(b) blockDim, 也是一个包含三个元素 x, y, z 的结构体，分别表示块在 x, y, z 三个方向上的尺寸；
(c) blockIdx, 也是一个包含三个元素 x, y, z 的结构体，分别表示当前线程所在块在网格中 x, y, z 三个方向上的索引；
(d) threadIdx, 也是一个包含三个元素 x, y, z 的结构体，分别表示当前线程在其所在块中 x, y, z 三个方向上的索引；
(e) warpSize，表明 warp 的尺寸，在计算能力为 1.0 的设备中，这个值是 24，在 1.0 以上的设备中，这个值是 32。

# 调用__global__ `func<<<Dg,Db, Ns, S>>>(param list)`

- Dg用于定义整个grid的维度和尺寸
- Db用于定义一个block的维度和尺寸
- Ns是一个可选参数，用于设置每个block除了静态分配的shared Memory以外，最多能动态分配的shared memory大小（shared memory是一个SM上的高速缓存，不是global memory），单位为byte,默认为 0
- S是一个cudaStream_t类型的可选参数，初始值为零，表示该核函数处在哪个流之中（不知道是干嘛的）,默认为 0。

有两个长`d * b`的数组做加法
```cpp
__global__ void add(){
    int loc = blockIdx.x*blockDim.x +threadIdx.x;
    c[loc] = a[loc] + b[loc]
}

int main(){
    add<<<d,b>>>()
}
```
有两张`width * height`的图像blend

```cpp
__global__ void add(){
    int loc = blockIdx.x*blockDim.x +threadIdx.x;
    c[loc] = a[loc] + b[loc]
}

int main(){
    add<<<1,b>>>()
}
```
# Compile
## nvcc

## cmake
```cmake
# https://devblogs.nvidia.com/parallelforall/building-cuda-applications-cmake/
cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(cuda LANGUAGES CXX CUDA)

ADD_EXECUTABLE(main main.cu)
```





