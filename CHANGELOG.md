# Changelog

🌐 **Language / 語言**：**English** | [繁體中文](CHANGELOG_zh.md)

## 0.5.2
#### 2026-08-25
- **World & Controller Lifecycle Cleanup**: Added `dispose()` alias to `RapierWorld`, improved `destroy()` to clear internal body, collider, and joint maps and nullify `_groundBody`.
- **Character Controller Safety**: Enhanced `KinematicCharacterController.dispose()` to reset controller handles safely and prevent double-free.

## 0.5.1
#### 2026-08-21
- **Character Controller Jump**: Added a **Jump** button to the `CharacterControllerScene` demo, enabling vertical impulse-based jumping with on-screen UI controls.
- **Joystick Input Improvements**: Refined joystick interaction in `CharacterControllerScene` with a configurable input area and improved touch responsiveness.
- **Windows DLL Updated**: Rebuilt and updated `prebuilt/rapier_ffi.dll`.
- **CompoundScene Table**: Added `addTable` — a compound rigid body consisting of a flat tabletop box and four box legs with individual `ColliderDesc.cuboid` offsets and darker-wood sub-mesh colouring.

## 0.5.0
#### 2026-08-19
- **Kinematic Character Controller**: Introduced `KinematicCharacterController` for 3D character physics navigation, supporting auto-stepping, slope sliding, ground snapping, and dynamic body impulse pushing (`applyImpulsesToDynamicBodies`).
- **Scene Queries**: Added comprehensive `SceneQuery` API featuring raycasting (`castRay`, `castRayAndGetNormal`, `intersectionWithRay`, `intersectionsWithRay`) and shape casting (`castShape`, `intersectionsWithShape`) with customizable query filter flags (`QueryFilterFlags`).
- **Explicit Capsule Axis Alignment**: Refactored `ColliderShapeType` and `ColliderDesc` to explicitly support axis-aligned capsule variants (`capsuleX`, `capsuleY`, `capsuleZ`) across Dart API and Rust FFI.
- **FFI Modularization**: Modularized native Rust FFI code into structured files (`world`, `rigid_body`, `collider`, `joint`, `character_controller`, `scene_query`) and split Dart FFI bindings into dedicated implementation modules (`lib/src/bindings/ffi/`).
- **New Interactive Demos**: Added 3D Character Controller demo and Scene Query raycasting/shape-casting demo in the example project (`example/lib/main_3d.dart`).
- **Engine Upgrade**: Upgraded the underlying native engine dependency to `rapier3d v0.34.0`.

## 0.4.1
#### 2026-07-19
- **CompoundScene Dumbbell Spawner**: Added time-based dumbbell spawning in `CompoundScene`, continuously spawning compound rigid bodies from `(0, 0, 20)` at 10/sec up to a configurable cap.
- **BaseScene Camera & Ground**: Increased default camera distance to 30 and expanded ground plane half-size to 10 with a larger checkerboard texture.

## 0.4.0
#### 2026-06-27
- **Windows Platform Support**: Added support for the Windows platform, including a C++ plugin implementation, CMake configuration, and bundling of the prebuilt native `rapier_ffi.dll` library.
- **Swift Package Manager (SPM) Support**: Restructured iOS and macOS native directories (`ios/rapier_physics` and `macos/rapier_physics`) and added `Package.swift` to support integration via Swift Package Manager.
- **Build Script Automation**: Refactored `native/rapier_ffi/build.sh` to output `.xcframework` directly to the iOS and macOS `rapier_physics` subfolders to match the SPM structure.

## 0.3.1
#### 2026-05-07
- **Timestep API**: Added `timestep` getter and setter to `RapierWorld`, allowing users to control the simulation's integration step size (`dt`).
- **FFI Naming Refactor**: Standardized all FFI function names to the `rapier_[component]_[action]` convention (e.g., `rapier_rigid_body_create`, `rapier_collider_get_position_x`) for better consistency across Native and Web platforms.
- **API Refinement**: Updated `ColliderDesc` constructors for `cylinder`, `cone`, and `capsule` to follow a more intuitive parameter order: `(radius, halfHeight)` instead of `(halfHeight, radius)`.
- **Platform Sync**: Updated iOS/macOS Swift plugins and Web/WASM bridge to support the new timestep FFI symbols and improve symbol visibility.


## 0.3.0
#### 2026-05-03
- **Unified Collider API**: Introduced `ColliderDesc` architecture for more robust and extensible collider creation.
- **Native Local Transform Support**: 
    - Added `localPosition` and `localRotation` support directly in the native FFI layer.
    - Colliders can now be positioned and rotated relative to their parent rigid body at creation time, improving physical stability.
- **API Cleanup**: 
    - Removed redundant specialized collider creation methods (`createBoxCollider`, `createSphereCollider`, etc.) in favor of the unified `createCollider` API.
    - Updated `addBox`, `addSphere`, and other convenience methods to use the unified `RigidBodyDesc` system for better extensibility.
- **FFI Memory Optimization**: Standardized the `ColliderDesc` memory layout (64 bytes) across Rust, Dart, and Swift for efficient zero-copy cross-boundary communication.
- **Platform Sync**: Updated iOS/macOS Swift plugins and Web/WASM interop to support the expanded native collider transformation data.

## 0.2.0
#### 2026-04-23
- **Force & Impulse API**: Added `addForce`, `addTorque`, `applyImpulse`, `applyTorqueImpulse`, and their `AtPoint` variants to `RigidBody`.
- **Velocity Controls**: Added `setLinearVelocity` and `setAngularVelocity` for fine-grained rigid body motion control.
- **Entity Removal API**: 
    - Added `removeRigidBody`, `removeCollider`, and `removeJoint` to `RapierWorld`.
    - Implemented automatic cleanup of internal tracking (e.g., removing a body also cleans up its associated colliders and joints from Dart state).
- **Relationship Tracking**: 
    - Added `colliders` and `joints` getters to `RigidBody` for bidirectional navigation between entities.
    - Improved internal `_bodyColliders` and `_bodyJoints` mapping for robust state management.
- **CCD Support**: Added `setCCD(bool enabled)` to `RigidBody` to prevent tunneling for high-speed objects.
- **Heightfield Colliders**: Added support for terrain-based collisions using height maps (`addHeightfield`).
- **Apple Platforms Refinement**: 
    - Improved symbol export and linking for iOS/macOS via Swift plugin bridge.
    - Added explicit `@_silgen_name` declarations for all FFI symbols to ensure stability in Release builds.
- **Joints Support**: Added comprehensive joint system including:
    - `FixedJoint`, `SphericalJoint`, `RevoluteJoint`, `PrismaticJoint`, `GenericJoint`, and `RopeJoint`.
    - Helper methods to attach bodies directly to the world (`*ToWorld`).
- **Motors & Constraints**: 
    - Added joint motor support for Revolute and Prismatic joints.
    - Added `lockJointAxis` and `setJointLimits` for fine-grained constraint control via `GenericJoint`.
- **New Colliders**: Added `Cone` collider support.
- **World Lifecycle**:
    - Added `destroy()` to `RapierWorld` for proper resource cleanup.
    - Native `groundBody` support for easier joint anchoring to the static world.
- **Engine Upgrade**: Upgraded the underlying native engine dependency to `rapier3d v0.32.0`.
- **Example App enhancements**: Added Newton's Cradle demo, debug toggles (helpers, wireframe), shadow controls, and physics restart.

## 0.1.0
#### 2026-04-09
- **Cross-Platform Refactoring**: Major architectural update to support Native and Web platforms seamlessly using abstract bindings and conditional imports.
- **Web Support**: Full WebAssembly (WASM) implementation via `dart:js_interop`.
- **Android Fix**: Resolved native library loading issues by adopting standard `jniLibs` directory structure and loading from name.
- **Improved API**:
    - Added asynchronous `init()` for robust cross-platform initialization.
    - Component-wise state getters for better WASM compatibility.
    - Support for multiple `RigidBodyType` (Fixed, Dynamic, Kinematic).
- **Automated Tooling**: Updated `build.sh` to automate the distribution of Android, iOS, macOS, and Web binaries.

## 0.0.1
#### 2026-04-03
- Initial release with basic Rapier physics FFI bridge.
