import 'dart:math' as math;

import 'rapier_world.dart';
import 'collider.dart';
import 'rigid_body.dart';

/// The result of a single [KinematicCharacterController.move] call.
class CharacterMovementResult {
  /// The collision-resolved movement that was actually applied to the character
  /// this frame. This is always ≤ the desired movement in each axis.
  final Vector3 correctedMovement;

  /// Whether the character was touching the ground at the end of the move.
  final bool isGrounded;

  /// Whether the character was touching a wall (lateral obstruction).
  final bool isOnWall;

  /// Whether the character was touching a ceiling.
  final bool isOnCeiling;

  const CharacterMovementResult({
    required this.correctedMovement,
    required this.isGrounded,
    required this.isOnWall,
    required this.isOnCeiling,
  });
}

/// A high-level wrapper around Rapier's [KinematicCharacterController].
///
/// This controller computes collision-safe movement for a kinematic character
/// each frame: given a desired movement vector it shape-casts the character's
/// collider through the world, resolves slopes / stairs / ceilings, and
/// returns the effective translation — together with grounded / wall / ceiling
/// contact flags.
///
/// ## Typical usage
/// ```dart
/// final ctrl = world.createCharacterController(body, collider);
/// ctrl.snapToGround = 0.3;
/// ctrl.maxSlopeAngle = math.pi / 4;  // 45°
///
/// // Each frame:
/// final velocity = Vector3(0, verticalVelocity, 0) + horizontalMovement;
/// final result = ctrl.move(velocity * dt, dt);
/// if (result.isGrounded) verticalVelocity = 0;
/// ```
///
/// Call [dispose] when the character is destroyed.
class KinematicCharacterController {
  final int _ctrlHandle;
  final RapierWorld _world;
  final RigidBody _body;
  final Collider _collider;

  KinematicCharacterController._(
    this._ctrlHandle,
    this._world,
    this._body,
    this._collider,
  );

  /// Creates a new character controller.
  ///
  /// [offset] is the skin distance — the small gap kept between the character
  /// shape and surfaces to avoid tunnelling. Typical value: 0.01.
  factory KinematicCharacterController.create(
    RapierWorld world,
    RigidBody body,
    Collider collider, {
    double offset = 0.01,
  }) {
    final handle = RapierWorld.bindings.createCharacterController(offset);
    return KinematicCharacterController._(handle, world, body, collider);
  }

  // ==========================================
  // Configuration
  // ==========================================

  /// The world-space "up" direction used by the controller.
  /// Defaults to (0, 1, 0).
  set upAxis(Vector3 up) {
    RapierWorld.bindings.setCharacterControllerUp(_ctrlHandle, up.x, up.y, up.z);
  }

  /// Maximum slope angle (radians) the character can walk up.
  /// Steeper slopes will cause the character to slide.
  /// Default: π/4 (45°).
  set maxSlopeAngle(double radians) {
    RapierWorld.bindings.setCharacterControllerMaxSlope(_ctrlHandle, radians);
  }

  /// Minimum slope angle (radians) below which sliding-down behaviour is
  /// suppressed (the character can stand on very shallow slopes without
  /// sliding). Default: π/20 (9°).
  set minSlopeAngle(double radians) {
    RapierWorld.bindings.setCharacterControllerMinSlope(_ctrlHandle, radians);
  }

  /// When set to a positive value, the character snaps to the ground by up to
  /// this distance when falling small amounts (e.g. going down stairs).
  /// Set to null to disable.
  set snapToGround(double? distance) {
    if (distance != null && distance > 0) {
      RapierWorld.bindings.setCharacterControllerSnapToGround(
        _ctrlHandle,
        distance,
        true,
      );
    } else {
      RapierWorld.bindings.setCharacterControllerSnapToGround(
        _ctrlHandle,
        0.0,
        false,
      );
    }
  }

  /// Configures automatic stair-climbing.
  ///
  /// [maxHeight] — maximum step height the character can climb.
  ///   Set to 0 or null to disable.
  /// [minWidth] — minimum step width required for climbing.
  /// [includeDynamicBodies] — whether dynamic (non-static) bodies count as steps.
  void setAutoStep({
    double maxHeight = 0.0,
    double minWidth = 0.1,
    bool includeDynamicBodies = false,
  }) {
    RapierWorld.bindings.setCharacterControllerAutoStep(
      _ctrlHandle,
      maxHeight,
      minWidth,
      includeDynamicBodies,
    );
  }

  // ==========================================
  // Movement
  // ==========================================

  /// Computes the collision-resolved movement for the character and applies
  /// it to the rigid body's kinematic next position.
  ///
  /// [desiredMovement] is the full movement this frame (e.g. velocity × dt).
  /// [dt] is the physics timestep.
  ///
  /// Returns a [CharacterMovementResult] with the effective movement and
  /// contact flags.
  CharacterMovementResult move(Vector3 desiredMovement, double dt) {
    final corrected = RapierWorld.bindings.moveCharacter(
      _world.worldHandle,
      _ctrlHandle,
      _collider.handle,
      desiredMovement.x,
      desiredMovement.y,
      desiredMovement.z,
      dt,
    );

    // Apply the corrected movement to the kinematic body's position.
    final currentPos = _body.position;
    _body.setPosition(currentPos + corrected);

    return CharacterMovementResult(
      correctedMovement: corrected,
      isGrounded: RapierWorld.bindings.isCharacterGrounded(_ctrlHandle),
      isOnWall: RapierWorld.bindings.isCharacterOnWall(_ctrlHandle),
      isOnCeiling: RapierWorld.bindings.isCharacterOnCeiling(_ctrlHandle),
    );
  }

  // ==========================================
  // Lifecycle
  // ==========================================

  /// Releases the native controller memory. Must be called when the character
  /// is destroyed. After calling [dispose] this object must not be used.
  void dispose() {
    if (_ctrlHandle != 0) {
      RapierWorld.bindings.destroyCharacterController(_ctrlHandle);
    }
  }
}

// Re-export dart:math pi for consumers who don't want an extra import.
// ignore: unused_element
final _kPi = math.pi;
