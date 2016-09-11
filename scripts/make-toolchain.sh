#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

WD=$(readlink -f "`dirname $0`/..")
TOOLCHAIN_DIR=${WD}/toolchains

mkdir -p "$TOOLCHAIN_DIR"

if [ "${ANDROID_ABI}" = "armeabi-v7a-hard-softfp with NEON" ]; then
    ARCH=arm
    TOOLCHAIN=arm-linux-androideabi-4.9
    ABI=armeabi-v7a
elif [ "${ANDROID_ABI}" = "arm64-v8a"  ]; then
    ARCH=arm
    TOOLCHAIN=aarch64-linux-android-4.9
    ABI=arm64-v8a
elif [ "${ANDROID_ABI}" = "armeabi"  ]; then
    ARCH=arm
    TOOLCHAIN=arm-linux-androideabi-4.9
    ABI=armeabi
elif [ "${ANDROID_ABI}" = "x86"  ]; then
    ARCH=x86
    TOOLCHAIN=x86-4.9
    ABI=x86
elif [ "${ANDROID_ABI}" = "x86_64"  ]; then
    ARCH=x86_64
    TOOLCHAIN=x86_64-4.9
    ABI=x86_64
else
    echo "Error: not support $0 for ABI: ${ANDROID_ABI}"
    exit 1
fi

$NDK_ROOT/build/tools/make-standalone-toolchain.sh --install-dir=$TOOLCHAIN_DIR/$ABI --platform=android-21 --arch=$ARCH --toolchain=$TOOLCHAIN --abis=$ABI
