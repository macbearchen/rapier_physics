# Changelog

## 0.2.0
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
