# Linker and loader nots

* 编译
    * pipline
        * token
        * 语法分析
        * 语义分析
        * 中间表达
        * 中间表达优化
        * 目标代码生成
        * 目标代码优化
    * 编译器前端 源码到中间表达
    * 编译器后端 中间表到到目标代码
* 目标文件格式
    * windows is portable executable
    * linux is executable linkable format
    * common file format(coff)
* gcc -c simplesection.c
* objdump -h simplesection.o
* size simpleSection.o
* objdump -s -d simpleSection.o
* objdump -x -s -d simpleSection.o
* readelf -h simpleSection.o


# gcc

## search path
### header search path
1. -I
2. C_INCLUDE_PATH,CPLUS_INCLUDE_PATH,OBJC_INCLUDE_PATH
    1. /usr/include
    2. /usr/local/include
    3. /usr/lib/gcc-lib/i386-linux/2.95.2/include
    4. /usr/lib/gcc-lib/i386-linux/2.95.2/../../../../include/g -3
    5. /usr/lib/gcc-lib/i386-linux/2.95.2/../../../../i386-linux/include
    6. prefix/include
    7. prefix/xxx-xxx-xxx-gnulibc/include
    8. prefix/lib/gcc-lib/xxxx-xxx-xxx-gnulibc/2.8.1/include

### static link library
1. -L -l
2. LIBRARY_PATH
3. /lib /usr/lib /usr/local/lib

### dynamic link library
1. -L -l # ?
2. -Wl,-rpath
3. LD_LIBRARY_PATH
4. /etc/ld.so.conf
5. /lib /usr/lib

## gcc arg
-I add header search
-L add static library search 
-l （el）添加链接库名称

## pkg-config
```bash
# PKG_CONFIG_PATH/*.pc
export PKG_CONFIG_PATH="PKG_CONFIG_PATH"
# include
pkg-config opencv --cflags

# libs
pkg-config opencv --libs
```

## platform diff
### dynamic lib file name
- mac: dylib
- linux: .so
### dynamic lib env name
- mac DYLD_LIBRARY_PATH
- linux LD_LIBRARY_PATH
### link inspect
- mac otool -L 
- linux ldd 

# CMAKE

## basic
```bash
cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(protject_name)
set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp)
add_executable(cmake ${SOURCE_FILES})
```
## set bin lib output dir
```bash
cmake_minimum_required(VERSION 3.7 FATAL_ERROR)
project(protject_name)
set(CMAKE_CXX_STANDARD 11)

set(
        CMAKE_RUNTIME_OUTPUT_DIRECTORY
        ${CMAKE_HOME_DIRECTORY}/bin
)

set(
        CMAKE_LIBRARY_OUTPUT_DIRECTORY
        ${CMAKE_HOME_DIRECTORY}/lib
)
```

## add library
```cmake
add_library(<name> [STATIC | SHARED | MODULE]
            [EXCLUDE_FROM_ALL]
            source1 [source2 ...])

```

## global set lib and include
```
set(demo_include …..)
set(demo_lib ….)
include_directories(${demo_include})
link_directories(${demo_lib})
```

## find Package
```bash
set(SOURCE_FILES …)
add_executable(main ${SOURCE_FILES})


# https://cmake.org/cmake/help/v3.0/command/find_package.html
find_package(gflags REQUIRED)
target_link_libraries(main gflags) 
```
## find library
```bash
find_library(LIB_LOCATION xxx)
target_link_libraries(ExecutableName ${LIB_LOCATION})
```

## pkg-conf
```bash
# https://cmake.org/cmake/help/v3.1/module/FindPkgConfig.html
find_package(PkgConfig REQUIRED)
pkg_search_module(SDL2 REQUIRED sdl2)

target_link_libraries(testapp ${SDL2_LIBRARIES})
target_include_directories(testapp PUBLIC ${SDL2_INCLUDE_DIRS})
target_compile_options(testapp PUBLIC ${SDL2_CFLAGS_OTHER})
```


