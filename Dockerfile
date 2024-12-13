# syntax=docker/dockerfile:experimental

FROM ubuntu:24.04 AS build
ENV DEBIAN_FRONTEND noninteractive
ENV CCACHE_DIR=/ccache
ENV CCACHE_MAXSIZE=25G

ARG LLVM_VERSION
ARG BASE_PATH=/llvm

RUN --mount=type=cache,id=1,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt update -y \
    && apt install -y llvm-dev build-essential git cmake binutils-gold ninja-build ccache zlib1g-dev

RUN mkdir -p ${BASE_PATH} ${BASE_PATH}/build
RUN git clone https://github.com/llvm/llvm-project.git ${BASE_PATH}/llvm
RUN cd ${BASE_PATH}/llvm  && \
    git checkout ${LLVM_VERSION}

WORKDIR ${BASE_PATH}/llvm
COPY ./patches ${BASE_PATH}/patches
RUN ls -alh && git apply ${BASE_PATH}/patches/${LLVM_VERSION}.patch

# RelWithDebInfo
WORKDIR ${BASE_PATH}/build
RUN --mount=type=cache,target=/ccache/ \
    cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=on -DLLVM_USE_LINKER=gold \
        -DLLVM_TARGETS_TO_BUILD=X86 -DLLVM_ENABLE_PROJECTS='clang;compiler-rt;lld' -DLLVM_INSTALL_UTILS=ON -DCMAKE_INSTALL_PREFIX=${BASE_PATH}/usr \
        -DLLVM_ENABLE_DUMP=off -DLLVM_ENABLE_ZLIB=on -DLLVM_CCACHE_BUILD=on -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ../llvm/llvm

RUN ninja && ninja install

FROM ubuntu:23.04
ENV DEBIAN_FRONTEND noninteractive
ARG BASE_PATH=/llvm

COPY --from=build ${BASE_PATH}/usr ${BASE_PATH}/usr

RUN --mount=type=cache,id=1,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt update -y \
    && apt install -y build-essential
