#!/bin/bash
set -e

DIST=../../prebuilt
DIST_ios=../../ios
DIST_macos=../../macos
DIST_android=../../android/src/main/jniLibs
#rm -rf $DIST
mkdir -p $DIST

# ===== Android NDK =====
export ANDROID_NDK_HOME=${ANDROID_NDK_HOME:-"$HOME/Library/Android/sdk/ndk/29.0.14206865"}
export ANDROID_API_LEVEL=28

# ===== Clean =====
echo "=== Cleaning ==="
cargo clean

# ===== Detect host platform =====
UNAME=$(uname -s)
echo "Host platform: $UNAME"

# ===== macOS dylib + iOS =====
if [[ "$UNAME" == "Darwin" ]]; then
    echo "=== macOS (static arm64 + x86_64) ==="
    rustup target add aarch64-apple-darwin x86_64-apple-darwin
    cargo build --release --target aarch64-apple-darwin
    cargo build --release --target x86_64-apple-darwin
    
    echo "=== Creating macOS XCFramework ==="
    rm -rf $DIST_macos/rapier_ffi.xcframework
    lipo -create \
        target/aarch64-apple-darwin/release/librapier_ffi.a \
        target/x86_64-apple-darwin/release/librapier_ffi.a \
        -output target/librapier_ffi_macos.a

    xcodebuild -create-xcframework \
        -library target/librapier_ffi_macos.a \
        -output $DIST_macos/rapier_ffi.xcframework

    echo "=== iOS device (arm64) ==="
    rustup target add aarch64-apple-ios
    cargo build --release --target aarch64-apple-ios

    echo "=== iOS simulator (arm64) ==="
    rustup target add aarch64-apple-ios-sim
    cargo build --release --target aarch64-apple-ios-sim

    echo "=== Creating XCFramework ==="
    rm -rf $DIST_ios/rapier_ffi.xcframework
    xcodebuild -create-xcframework \
        -library target/aarch64-apple-ios/release/librapier_ffi.a \
        -library target/aarch64-apple-ios-sim/release/librapier_ffi.a \
        -output $DIST_ios/rapier_ffi.xcframework

    SKIP_LINUX_WINDOWS=1
fi

# ===== Android =====
echo "=== Android (SO) ==="
rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android

mkdir -p .cargo
cat > .cargo/config.toml <<EOL
[target.aarch64-linux-android]
ar = "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android-ar"
linker = "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/aarch64-linux-android${ANDROID_API_LEVEL}-clang"

[target.armv7-linux-androideabi]
ar = "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-ar"
linker = "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/armv7a-linux-androideabi${ANDROID_API_LEVEL}-clang"

[target.x86_64-linux-android]
ar = "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/x86_64-linux-android-ar"
linker = "${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/darwin-x86_64/bin/x86_64-linux-android${ANDROID_API_LEVEL}-clang"
EOL

cargo build --release --target aarch64-linux-android
cargo build --release --target armv7-linux-androideabi
cargo build --release --target x86_64-linux-android

mkdir -p $DIST_android/arm64-v8a
mkdir -p $DIST_android/armeabi-v7a
mkdir -p $DIST_android/x86_64

cp target/aarch64-linux-android/release/librapier_ffi.so $DIST_android/arm64-v8a/
cp target/armv7-linux-androideabi/release/librapier_ffi.so $DIST_android/armeabi-v7a/
cp target/x86_64-linux-android/release/librapier_ffi.so $DIST_android/x86_64/

# ===== Linux (SO) =====
if [[ "$UNAME" == "Linux" ]]; then
    echo "=== Linux (SO) ==="
    rustup target add x86_64-unknown-linux-gnu
    cargo build --release --target x86_64-unknown-linux-gnu
    cp target/x86_64-unknown-linux-gnu/release/librapier_ffi.so $DIST/
else
    echo "=== Skipping Linux build on non-Linux host ==="
fi

# ===== Windows (DLL) =====
if [[ "$UNAME" == "MINGW64_NT"* || "$UNAME" == "MSYS_NT"* || "$UNAME" == "Windows_NT" ]]; then
    echo "=== Windows (DLL) ==="
    rustup target add x86_64-pc-windows-msvc
    cargo build --release --target x86_64-pc-windows-msvc
    cp target/x86_64-pc-windows-msvc/release/rapier_ffi.dll $DIST/
else
    echo "=== Skipping Windows build on non-Windows host ==="
fi

# ===== Web (WASM) =====
echo "=== Web (WASM) ==="
rustup target add wasm32-unknown-unknown
cargo build --release --target wasm32-unknown-unknown
mkdir -p $DIST/web
cp target/wasm32-unknown-unknown/release/rapier_ffi.wasm $DIST/web/
mkdir -p ../../example/web
cp target/wasm32-unknown-unknown/release/rapier_ffi.wasm ../../example/web/

# ===== Finish =====
echo "=== Build finished ==="
ls -lh $DIST