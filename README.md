# Rapier Physics for Flutter

A high-performance physics engine for Flutter, powered by [Rapier](https://rapier.rs/). This plugin provides cross-platform support for 3D physics simulation using Rust and WebAssembly.

## Features

- **Cross-Platform**: Support for Android, iOS, macOS, and Web.
- **High Performance**: Core physics simulation written in Rust.
- **Flexible Physics**: Support for various rigid body types (Dynamic, Fixed, Kinematic).
- **Colliders**: Box, Sphere, Cylinder, and Capsule colliders.
- **Modern Web Support**: Efficient WASM implementation using `dart:js_interop`.

## Getting Started

### 1. Build Native Libraries
To use the plugin on native platforms or the web, you must first compile the Rust FFI layer.

```bash
cd native/rapier_ffi
./build.sh
```

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
    x: 0, y: 0, z: 0, 
    hx: 10.0, hy: 0.1, hz: 10.0, 
    type: RigidBodyType.fixed
  );

  // 3. Add a dynamic falling box
  final box = world.addBox(
    x: 0, y: 10, z: 0, 
    hx: 0.5, hy: 0.5, hz: 0.5
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