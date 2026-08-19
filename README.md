# Rapier Physics for Flutter

[![pub package](https://img.shields.io/pub/v/rapier_physics.svg)](https://pub.dev/packages/rapier_physics)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platform](https://img.shields.io/badge/platform-ios%20%7C%20android%20%7C%20macos%20%7C%20windows%20%7C%20web-blue)

[繁體中文](./README_zh.md)

A high-performance physics engine for Flutter, powered by [Rapier](https://rapier.rs/). This plugin provides cross-platform support for 3D physics simulation using Rust and WebAssembly.

[**Live Web Demo**](https://macbearchen.github.io/rapier_physics/)

## Features

- **Cross-Platform**: Support for Android, iOS, macOS, Windows, and Web.
- **High Performance**: Core physics simulation written in Rust.
- **Flexible Physics**: Support for various rigid body types (Dynamic, Fixed, Kinematic).
- **Character Controller**: Kinematic character controller supporting auto-stepping, slope sliding, ground snapping, and dynamic body pushing.
- **Scene Queries**: Raycasting (`castRay`, `castRayAndGetNormal`, `intersectionWithRay`, `intersectionsWithRay`) and shape casting (`castShape`, `intersectionsWithShape`) with filter flags.
- **Force & Impulse**: Full support for `addForce`, `applyImpulse`, and their `AtPoint` variants.
- **Velocity Control**: Set linear and angular velocities directly for precise state control.
- **Colliders**: Box, Sphere, Cylinder, Capsule (`capsuleX`, `capsuleY`, `capsuleZ`), Cone, and **Heightfield** colliders with **native local transform support** (`localPosition`, `localRotation`).
- **Joints Support**: Fixed, Spherical, Revolute, Prismatic, and Rope joints with motor support.
- **Lifecycle Management**: Robust API for adding and **removing** rigid bodies, colliders, and joints with automatic relationship cleanup.
- **CCD**: Continuous Collision Detection for high-speed simulation.
- **Timestep Control**: Get and set the simulation integration step size (`dt`) via `RapierWorld.timestep`.
- **Modern Web Support**: Efficient WASM implementation using `dart:js_interop`.
- **Modern Apple Platform Integration**: Full Swift Package Manager (SPM) support alongside CocoaPods.

## Getting Started

### Installation

Add `rapier_physics` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  rapier_physics: ^0.5.0
```

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
- Compile `.a` files for iOS/macOS, packaging them into `.xcframework` bundles, and distribute them into the platform subdirectories to support Swift Package Manager (SPM).
- Compile `.dll` files for Windows (when run on Windows host) and place them in the `prebuilt/` directory.
- Compile `.wasm` for the Web and place it in the example project.

### Basic Usage

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

### 3D Interactive Demos

The example project contains multiple interactive 3D physics demos powered by the [macbear_3d](https://pub.dev/packages/macbear_3d) rendering engine and integrated via `M3RapierPhysicsEngine`.

To run the 3D physics demos:

```bash
cd example
flutter run -t lib/main_3d.dart
```

These demos include:
1. **Basic Physics Scene**: Rigid body dynamics, gravity, and basic collisions (Box, Sphere, Cylinder, Capsule, Cone) with an interactive motorized joint.
2. **Newton's Cradle**: Momentum conservation demo using spherical joint constraints.
3. **Double Pendulum**: Chaotic motion simulation with revolute and spherical joints.
4. **Compound Shapes**: Rigid bodies consisting of multiple colliders (e.g., table with four legs).
5. **Character Controller**: 3D player movement with auto-stepping, slope sliding, and pushing dynamic obstacles.
6. **Scene Queries**: Raycasting and shape casting with dynamic visualization and hit filtering.

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