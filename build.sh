#!/usr/bin/env bash
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo "Either NDK_ROOT should be set or provided as argument"
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT=$(readlink -f "${1:-${NDK_ROOT}}")
    export NDK_ROOT="${NDK_ROOT}"
fi

WD=$(readlink -f "$(dirname "$0")")
cd "${WD}"

export ANDROID_ABI="${ANDROID_ABI:-"arm64-v8a"}"
HOST_CPUS=$(cat /proc/cpuinfo | awk '/^processor/{print $3}' | tail -1)
HOST_CPUS=$((${HOST_CPUS} + 2))
export N_JOBS=${N_JOBS:-${HOST_CPUS}}

if ! ./scripts/build_openblas.sh ; then
    echo "Failed to build OpenBLAS"
    exit 1
fi

./scripts/build_boost.sh
./scripts/build_gflags.sh
./scripts/build_glog.sh
./scripts/build_lmdb.sh
./scripts/build_opencv.sh
./scripts/build_protobuf_host.sh
./scripts/build_protobuf.sh
./scripts/build_caffe.sh

echo "DONE!!"
