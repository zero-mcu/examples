#!/bin/bash

source $ZERO_MCU_HOME/scripts/env.sh
project_dir=$(cd "$(dirname "$0")"; 'pwd')
echo "project_dir=$project_dir"
build_dir=$project_dir/build
build_type="Debug"

build_project()
{
    echo "build project"
    mkdir -p $build_dir
    cd $build_dir

    if [ $build_type = "Debug" ]; then
        cmake -DCMAKE_BUILD_TYPE="Debug" -DZERO_SDK_PATH=$ZERO_SDK_PATH -DCMAKE_TOOLCHAIN_FILE=$ZERO_STM32_CMAKE_TOOLCHAIN_FILE -DSTM32Cube_DIR=${ZERO_3RD_PATH}/STM32Cube_FW_F1_V1.7.0 -DTOOLCHAIN_PREFIX=$ZERO_GCC_TOOLCHAIN_PREFIX $project_dir
    elif [ $build_type = "Release" ]; then
        cmake -DCMAKE_BUILD_TYPE="Release" -DZERO_SDK_PATH=$ZERO_SDK_PATH -DCMAKE_TOOLCHAIN_FILE=$ZERO_STM32_CMAKE_TOOLCHAIN_FILE -DSTM32Cube_DIR=${ZERO_3RD_PATH}/STM32Cube_FW_F1_V1.7.0 -DTOOLCHAIN_PREFIX=$ZERO_GCC_TOOLCHAIN_PREFIX $project_dir
    fi
    make
}


clean_project()
{
    echo "clean project"
    rm -rf $build_dir
    exit 1
}

Usage()
{
    echo "----------------------------------------
Usage:
    sh build.sh [debug|release]
    sh build.sh clean
------------------------------------------"
    exit 1
}

if [ "$#" -eq 1 ] && [ "$1" = "-h" ]; then
    Usage
fi

if [ "$#" -eq 1 ]; then
    if [ "$1" = "clean" ]; then
        clean_project
    elif [ "$1" = "debug" ]; then
        build_type="Debug"
    elif [ "$1" = "release" ]; then
        build_type="Release"
    else
        Usage
    fi
elif [ "$#" -gt 1 ]; then
    Usage
fi

build_project


