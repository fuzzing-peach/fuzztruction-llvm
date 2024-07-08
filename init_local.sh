#!/bin/bash

rm -rf build-release
mkdir -p build-release

cd build-release
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=on -DLLVM_USE_LINKER=gold \
        -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld' -DLLVM_INSTALL_UTILS=ON -DCMAKE_INSTALL_PREFIX=/usr \
        -DLLVM_ENABLE_DUMP=on -DLLVM_ENABLE_ZLIB=on -DLLVM_CCACHE_BUILD=off -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ../llvm-project/llvm

cd ..
rm -rf build-debug
mkdir -p build-debug

cd build-debug
cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebug -DBUILD_SHARED_LIBS=on -DLLVM_USE_LINKER=gold \
        -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld' -DLLVM_INSTALL_UTILS=ON -DCMAKE_INSTALL_PREFIX=/usr \
        -DLLVM_ENABLE_DUMP=on -DLLVM_ENABLE_ZLIB=on -DLLVM_CCACHE_BUILD=off -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ../llvm-project/llvm
