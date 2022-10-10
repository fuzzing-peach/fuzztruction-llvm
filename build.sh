#!/usr/bin/env bash

set -eu
#LLVM_VERSION="12.0.1"
LLVM_VERSION="11.0.1"

#REMOTE_SERVER=blade-7
#export DOCKER_HOST=ssh://$REMOTE_SERVER
export DOCKER_BUILDKIT=1

# See llvmorg-* tags on the llvm git repository
# -> https://github.com/llvm/llvm-project.git
TAG=llvm_debug:${LLVM_VERSION}
IMAGE="fuzztruction-$TAG"
# Push Docker image to the given URL if set.
# PUSH_URL=nbars/$IMAGE

docker build --build-arg LLVM_VERSION=${LLVM_VERSION} -t ${IMAGE} .
if [[ ! -z "${PUSH_URL:-}" ]]; then
    docker tag ${IMAGE} $PUSH_URL
    cmd="docker push $PUSH_URL"
    echo "[+] $cmd"
    $cmd
fi