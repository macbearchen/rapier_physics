import "rapier_world.dart";
import "rigid_body.dart";

/// Tuning parameters for a wheel's suspension behaviour.
/// Pass 0 for any field to use rapier's built-in default.
class WheelTuning {
  /// Suspension stiffness. Default: ~5.88.
  final double suspensionStiffness;

  /// Damping when compressing. Default: ~0.83.
  final double suspensionCompression;

  /// Damping when rebounding. Default: ~0.88.
  final double suspensionDamping;

  /// Max travel above/below rest length (m). Default: 5.0.
  final double maxSuspensionTravel;

  /// Tyre traction multiplier. Default: 10.5.
  final double frictionSlip;

  /// Max suspension force (N). Default: 6000.
  final double maxSuspensionForce;

  const WheelTuning({
    this.suspensionStiffness = 0,
    this.suspensionCompression = 0,
    this.suspensionDamping = 0,
    this.maxSuspensionTravel = 0,
    this.frictionSlip = 0,
    this.maxSuspensionForce = 0,
  });

  /// Sensible defaults for a typical car.
  const WheelTuning.car()
    : suspensionStiffness = 30.0,
      suspensionCompression = 2.4,
      suspensionDamping = 4.4,
      maxSuspensionTravel = 0.5,
      frictionSlip = 10.5,
      maxSuspensionForce = 6000.0;
}

/// Per-wheel physics state read back after each [VehicleController.update].
class WheelState {
  /// Spin rotation around axle (radians).
  final double rotation;

  /// Current steering angle (radians).
  final double steering;

  /// Suspension compression (metres).
  final double suspensionLength;

  /// True when the wheel is touching the ground.
  final bool isInContact;

  /// World-space centre of the wheel.
  final Vector3 center;

  /// World-space contact point (meaningful only when [isInContact]).
  final Vector3 contactPoint;

  /// World-space surface normal at contact.
  final Vector3 contactNormal;

  /// Raw collider handle of the ground surface, or -1.
  final int groundColliderHandle;

  const WheelState({
    required this.rotation,
    required this.steering,
    required this.suspensionLength,
    required this.isInContact,
    required this.center,
    required this.contactPoint,
    required this.contactNormal,
    required this.groundColliderHandle,
  });
}

/// High-level Dart wrapper around rapier's [DynamicRayCastVehicleController].
///
/// ## Typical usage
/// ~~~dart
/// final chassis = world.createRigidBody(RigidBodyDesc.dynamic()..setTranslation(0, 2, 0));
/// chassis.createCollider(ColliderDesc.cuboid(1.0, 0.25, 2.0));
///
/// // Y = up, Z = forward
/// final vehicle = VehicleController.create(world, chassis, upAxis: 1, forwardAxis: 2);
///
/// final tuning = const WheelTuning.car();
/// vehicle.addWheel(Vector3( 0.9, -0.25,  1.4), tuning: tuning);  // FL
/// vehicle.addWheel(Vector3(-0.9, -0.25,  1.4), tuning: tuning);  // FR
/// vehicle.addWheel(Vector3( 0.9, -0.25, -1.4), tuning: tuning);  // RL
/// vehicle.addWheel(Vector3(-0.9, -0.25, -1.4), tuning: tuning);  // RR
///
/// // Each frame:
/// vehicle.setSteering(0, steer);
/// vehicle.setSteering(1, steer);
/// vehicle.setEngineForce(2, throttle);
/// vehicle.setEngineForce(3, throttle);
/// vehicle.update();      // MUST be called before world.step()
/// world.step();
///
/// for (var i = 0; i < vehicle.wheelCount; i++) {
///   final s = vehicle.wheelState(i);
///   meshes[i].position = s.center;
/// }
///
/// vehicle.dispose();
/// ~~~
class VehicleController {
  int _handle;
  final RapierWorld _world;
  final RigidBody _chassis;

  /// The chassis rigid body associated with this vehicle.
  RigidBody get chassis => _chassis;

  VehicleController._(this._handle, this._world, this._chassis);

  /// Creates a vehicle controller for [chassis].
  ///
  /// [upAxis]      – 0=X, 1=Y, 2=Z (default 1, i.e. +Y is up).
  /// [forwardAxis] – 0=X, 1=Y, 2=Z (default 2, i.e. +Z is forward).
  factory VehicleController.create(RapierWorld world, RigidBody chassis, {int upAxis = 1, int forwardAxis = 2}) {
    final handle = RapierWorld.bindings.createVehicle(chassis.handle, upAxis, forwardAxis);
    return VehicleController._(handle, world, chassis);
  }

  // ============================================================
  // Wheel setup
  // ============================================================

  /// Adds a wheel and returns its 0-based index.
  ///
  /// [connectionPoint] – chassis-local attachment point.
  /// [direction]        – suspension ray direction (chassis space).
  ///                      Defaults to straight down: (0, -1, 0).
  /// [axle]             – spin axis (chassis space). Defaults to (-1, 0, 0).
  /// [suspensionRestLength] – unloaded spring length (m).
  /// [radius]           – wheel radius (m).
  int addWheel(
    Vector3 connectionPoint, {
    Vector3? direction,
    Vector3? axle,
    double suspensionRestLength = 0.3,
    double radius = 0.35,
    WheelTuning tuning = const WheelTuning(),
  }) {
    final dir = direction ?? Vector3(0, -1, 0);
    final ax = axle ?? Vector3(-1, 0, 0);
    return RapierWorld.bindings.addVehicleWheel(
      _handle,
      connectionX: connectionPoint.x,
      connectionY: connectionPoint.y,
      connectionZ: connectionPoint.z,
      directionX: dir.x,
      directionY: dir.y,
      directionZ: dir.z,
      axleX: ax.x,
      axleY: ax.y,
      axleZ: ax.z,
      suspensionRestLength: suspensionRestLength,
      radius: radius,
      suspensionStiffness: tuning.suspensionStiffness,
      suspensionCompression: tuning.suspensionCompression,
      suspensionDamping: tuning.suspensionDamping,
      maxSuspensionTravel: tuning.maxSuspensionTravel,
      frictionSlip: tuning.frictionSlip,
      maxSuspensionForce: tuning.maxSuspensionForce,
    );
  }

  /// Number of wheels attached to this vehicle.
  int get wheelCount => RapierWorld.bindings.vehicleWheelCount(_handle);

  // ============================================================
  // Per-wheel inputs  (set before calling update() each frame)
  // ============================================================

  /// Sets the steering angle (radians) on [wheelIndex].
  void setSteering(int wheelIndex, double radians) =>
      RapierWorld.bindings.setVehicleSteering(_handle, wheelIndex, radians);

  /// Sets the engine force (N) on [wheelIndex]. Positive = forwards.
  void setEngineForce(int wheelIndex, double force) =>
      RapierWorld.bindings.setVehicleEngineForce(_handle, wheelIndex, force);

  /// Sets the brake force (N) on [wheelIndex].
  void setBrake(int wheelIndex, double brake) => RapierWorld.bindings.setVehicleBrake(_handle, wheelIndex, brake);

  // ============================================================
  // Simulation step
  // ============================================================

  /// Computes wheel forces and applies them to the chassis.
  ///
  /// **Must be called *before* [RapierWorld.step] every frame.**
  ///
  /// If [dt] is omitted, [RapierWorld.timestep] is used automatically.
  void update([double? dt]) {
    final timestep = dt ?? _world.timestep;
    RapierWorld.bindings.updateVehicle(_world.worldHandle, _handle, timestep);
  }

  // ============================================================
  // State read-back
  // ============================================================

  /// Forward speed of the chassis (m/s) after the last [update].
  double get currentSpeed => RapierWorld.bindings.vehicleCurrentSpeed(_handle);

  /// Full physics state of wheel [wheelIndex] after the last [update].
  WheelState wheelState(int wheelIndex) => WheelState(
    rotation: RapierWorld.bindings.vehicleWheelRotation(_handle, wheelIndex),
    steering: RapierWorld.bindings.vehicleWheelSteering(_handle, wheelIndex),
    suspensionLength: RapierWorld.bindings.vehicleWheelSuspensionLength(_handle, wheelIndex),
    isInContact: RapierWorld.bindings.vehicleWheelIsInContact(_handle, wheelIndex),
    center: RapierWorld.bindings.vehicleWheelCenter(_handle, wheelIndex),
    contactPoint: RapierWorld.bindings.vehicleWheelContactPoint(_handle, wheelIndex),
    contactNormal: RapierWorld.bindings.vehicleWheelContactNormal(_handle, wheelIndex),
    groundColliderHandle: RapierWorld.bindings.vehicleWheelGroundObject(_handle, wheelIndex),
  );

  /// World-space centre of wheel [wheelIndex].
  Vector3 wheelCenter(int wheelIndex) => RapierWorld.bindings.vehicleWheelCenter(_handle, wheelIndex);

  /// Whether wheel [wheelIndex] is touching the ground.
  bool wheelIsInContact(int wheelIndex) => RapierWorld.bindings.vehicleWheelIsInContact(_handle, wheelIndex);

  // ============================================================
  // Lifecycle
  // ============================================================

  /// Releases native memory. The object must not be used after this call.
  void dispose() {
    final h = _handle;
    if (h != 0) {
      _handle = 0;
      RapierWorld.bindings.destroyVehicle(h);
    }
  }
}
