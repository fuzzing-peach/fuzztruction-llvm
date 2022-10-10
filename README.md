# LLVM with Patched Stackmap Support (<b><span style="color:red">experimental</span></b>)
This repository provides everything needed to build LLVM with patched stackmap support. On a host with a working Docker installation, executing `./build.sh` is sufficient for building a Docker image containing the patched installation of LLVM at `/llvm`.

Since recompiling LLVM from scratch requires decent hardware, a pre-built image is provided at [Docker Hub](https://hub.docker.com/repository/docker/nbars/fuzztruction-llvm_debug).


> <b><span style="color:red">WARNING:</span></b> The provided patches are experimental and not production ready. They are provided as-is, however, we hope they serve as a starting point for people with more experience with LLVM to fix LLVM's stackmap support.
