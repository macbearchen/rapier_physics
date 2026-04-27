# Rapier Physics for Flutter

[繁體中文](./README_zh.md)

A high-performance physics engine for Flutter, powered by [Rapier](https://rapier.rs/). This plugin provides cross-platform support for 3D physics simulation using Rust and WebAssembly.

## Features

- **Cross-Platform**: Support for Android, iOS, macOS, and Web.
- **High Performance**: Core physics simulation written in Rust.
- **Flexible Physics**: Support for various rigid body types (Dynamic, Fixed, Kinematic).
- **Force & Impulse**: Full support for `addForce`, `applyImpulse`, and their `AtPoint` variants.
- **Velocity Control**: Set linear and angular velocities directly for precise state control.
- **Colliders**: Box, Sphere, Cylinder, Capsule, Cone, and **Heightfield** colliders with **native local transform support** (`localPosition`, `localRotation`).
- **Joints Support**: Fixed, Spherical, Revolute, Prismatic, and Rope joints with motor support.
- **Lifecycle Management**: Robust API for adding and **removing** rigid bodies, colliders, and joints with automatic relationship cleanup.
- **CCD**: Continuous Collision Detection for high-speed simulation.
- **Modern Web Support**: Efficient WASM implementation using `dart:js_interop`.

## Getting Started

### Setup

Choose one of the following methods to set up the native libraries:

#### 1. Use Prebuilt Library
If you prefer not to build from source, you can use the prebuilt binaries provided in the repository.

#### 2. Build by Yourself
To build the library from source, follow these steps:

**Install Cargo**
- 2-1. `curl https://sh.rustup.rs -sSf | sh`
- 2-2. `source $HOME/.cargo/env`
- 2-3. `cargo --version`

**Build Library**
- 2-4. `cd native/rapier_ffi`
- 2-5. `./build.sh`

This script will:

- Compile `.so` files for Android and place them in `android/src/main/jniLibs`.
- Compile `.a` files for iOS/macOS and create a `.xcframework`.
- Compile `.wasm` for the Web and place it in the example project.

### 2. Basic Usage

Initialize the `RapierWorld` and start simulating:

```dart
import 'package:rapier_physics/rapier_physics.dart';

void main() async {
  // 1. Initialize the world (asynchronous for WASM support)
  final world = RapierWorld();
  await world.init();

  // 2. Add a static floor
  world.addBox(
    hx: 10.0, hy: 0.1, hz: 10.0, 
    desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 0)
  );

  // 3. Add a dynamic falling box
  final box = world.addBox(
    hx: 0.5, hy: 0.5, hz: 0.5,
    desc: RigidBodyDesc.dynamic()..position = Vector3(0, 10, 0)
  );

  // 4. Step the simulation in your game loop
  Timer.periodic(Duration(milliseconds: 16), (timer) {
    world.step();
    print('Box Position: ${box.position}');
  });
}
```

## Supported Rigid Body Types

- `RigidBodyType.dynamic`: Fully simulated by physics.
- `RigidBodyType.fixed`: Static object, does not move.
- `RigidBodyType.kinematicPositionBased`: Moved by setting position.
- `RigidBodyType.kinematicVelocityBased`: Moved by setting velocity.

## Project Structure

- `lib/`: Dart source code and bindings logic.
- `native/rapier_ffi/`: Rust source code for the physics bridge.
- `example/`: Flutter example application.

## License

This project is licensed under the MIT License.