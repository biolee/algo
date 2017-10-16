cmake_minimum_required(VERSION 3.8 FATAL_ERROR)

project(cuda LANGUAGES CXX CUDA)

ADD_EXECUTABLE(main_nosync main_nosync.cu)
ADD_EXECUTABLE(main_sync main_sync.cu)

ADD_EXECUTABLE(main main.cu)
