#include <cstdio>
#include <cuda_runtime.h>

__global__ void p(){
  printf("1");
}

int main(int argc, char ** argv){
  p<<<1,1>>>();
}