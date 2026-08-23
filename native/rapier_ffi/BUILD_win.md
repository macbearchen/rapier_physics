# Windows Rust Setup & Native Build Guide

This guide covers how to install Rust (and Cargo) on Windows and build the `rapier_ffi` native library (`.dll` / `.wasm`).

---

## 1. Prerequisites: Visual Studio C++ Build Tools

Rust on Windows (MSVC ABI) requires the Microsoft C++ build tools and Windows SDK.

1. Download the installer from [Visual Studio C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/).
2. Run the installer and select the workload:
   - **Desktop development with C++** (includes MSVC compiler and Windows 10/11 SDK).
3. Complete the installation and reboot if prompted.

---

## 2. Install Rust & Cargo

### Option A: Using `winget` (Recommended)

Run the following command in PowerShell:

```powershell
winget install Rustlang.Rustup
```

### Option B: Official Installer

1. Download `rustup-init.exe` from [rustup.rs](https://rustup.rs/) (or [win.rustup.rs](https://win.rustup.rs/x86_64)).
2. Run `rustup-init.exe` and choose **1) Proceed with standard installation (default - x86_64-pc-windows-msvc)**.

---

## 3. Verify Installation

Open a **new** PowerShell or Command Prompt terminal (to reload `PATH`):

```powershell
rustc --version
cargo --version
rustup --version
```

---

## 4. Install Required Target Toolchains

For building Windows DLLs and WebAssembly:

```powershell
# Windows 64-bit MSVC target (usually default)
rustup target add x86_64-pc-windows-msvc

# WebAssembly target (for web support)
rustup target add wasm32-unknown-unknown
```

---

## 5. Building `rapier_ffi` on Windows

From this directory (`native/rapier_ffi`):

### Build Windows DLL (`rapier_ffi.dll`)

```powershell
cargo build --release --target x86_64-pc-windows-msvc
```

Output DLL will be generated at:
```
target/x86_64-pc-windows-msvc/release/rapier_ffi.dll
```

Copy the built DLL to prebuilt folder:
```powershell
New-Item -ItemType Directory -Force -Path ..\..\prebuilt
Copy-Item target\x86_64-pc-windows-msvc\release\rapier_ffi.dll ..\..\prebuilt\
```

### Build WebAssembly (`rapier_ffi.wasm`)

```powershell
cargo build --release --target wasm32-unknown-unknown
```

Output WASM will be generated at:
```
target/wasm32-unknown-unknown/release/rapier_ffi.wasm
```

Copy WASM to web assets:
```powershell
New-Item -ItemType Directory -Force -Path ..\..\prebuilt\web
Copy-Item target\wasm32-unknown-unknown\release\rapier_ffi.wasm ..\..\prebuilt\web\
```

---

## 6. Running with Git Bash (`build.sh`)

If you have **Git Bash** installed on Windows:

```bash
cd native/rapier_ffi
bash build.sh
```
