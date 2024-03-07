cmake_minimum_required(VERSION 3.26)
project(STEK C)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(STEK
        stek.c
        stek.h)
