# Changelog

## 0.1.0
- **Cross-Platform Refactoring**: Major architectural update to support Native and Web platforms seamlessly using abstract bindings and conditional imports.
- **Web Support**: Full WebAssembly (WASM) implementation via `dart:js_interop`.
- **Android Fix**: Resolved native library loading issues by adopting standard `jniLibs` directory structure and loading from name.
- **Improved API**:
    - Added asynchronous `init()` for robust cross-platform initialization.
    - Component-wise state getters for better WASM compatibility.
    - Support for multiple `RigidBodyType` (Fixed, Dynamic, Kinematic).
- **Automated Tooling**: Updated `build.sh` to automate the distribution of Android, iOS, macOS, and Web binaries.

## 0.0.1
- Initial release with basic Rapier physics FFI bridge.
