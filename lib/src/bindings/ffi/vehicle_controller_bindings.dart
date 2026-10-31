part of 'rapier_bindings_impl.dart';

// ==========================================
// Native (C) signatures
// ==========================================

// Vehicle lifecycle
typedef _CreateVehicleC = Pointer<Void> Function(Uint32, Uint32, Uint32);
typedef _DestroyVehicleC = Void Function(Pointer<Void>);

// Wheel management
typedef _AddVehicleWheelC = Uint32 Function(
    Pointer<Void>,
    Float, Float, Float,  // chassis_connection
    Float, Float, Float,  // direction
    Float, Float, Float,  // axle
    Float, Float,         // rest_length, radius
    Float, Float, Float, Float, Float, Float  // tuning
);
typedef _WheelCountC = Uint32 Function(Pointer<Void>);

// Per-wheel inputs
typedef _SetWheelScalarC = Void Function(Pointer<Void>, Uint32, Float);

// Update
typedef _VehicleUpdateC = Void Function(Pointer<Void>, Pointer<Void>, Float);

// Scalar getters
typedef _GetWheelScalarC = Float Function(Pointer<Void>, Uint32);
typedef _GetWheelBoolC = Bool Function(Pointer<Void>, Uint32);

// Vec3 out-param getters
typedef _GetWheelVec3C = Void Function(
    Pointer<Void>, Uint32,
    Pointer<Float>, Pointer<Float>, Pointer<Float>
);

// Vehicle-level scalar
typedef _GetVehicleScalarC = Float Function(Pointer<Void>);

// Ground object
typedef _GetWheelGroundObjectC = Uint32 Function(Pointer<Void>, Uint32);

// ==========================================
// Dart signatures
// ==========================================

typedef _CreateVehicleDart = Pointer<Void> Function(int, int, int);
typedef _DestroyVehicleDart = void Function(Pointer<Void>);

typedef _AddVehicleWheelDart = int Function(
    Pointer<Void>,
    double, double, double,
    double, double, double,
    double, double, double,
    double, double,
    double, double, double, double, double, double
);
typedef _WheelCountDart = int Function(Pointer<Void>);

typedef _SetWheelScalarDart = void Function(Pointer<Void>, int, double);

typedef _VehicleUpdateDart = void Function(Pointer<Void>, Pointer<Void>, double);

typedef _GetWheelScalarDart = double Function(Pointer<Void>, int);
typedef _GetWheelBoolDart = bool Function(Pointer<Void>, int);

typedef _GetWheelVec3Dart = void Function(
    Pointer<Void>, int,
    Pointer<Float>, Pointer<Float>, Pointer<Float>
);

typedef _GetVehicleScalarDart = double Function(Pointer<Void>);

typedef _GetWheelGroundObjectDart = int Function(Pointer<Void>, int);

/// FFI bindings for `DynamicRayCastVehicleController`: lifecycle, wheel
/// management, per-wheel inputs, simulation update, and state read-back.
mixin VehicleControllerBindings on FfiBindingsBase {
  late _CreateVehicleDart _createVehicleNative;
  late _DestroyVehicleDart _destroyVehicleNative;
  late _AddVehicleWheelDart _addVehicleWheelNative;
  late _WheelCountDart _vehicleWheelCountNative;
  late _SetWheelScalarDart _setVehicleSteeringNative;
  late _SetWheelScalarDart _setVehicleEngineForceNative;
  late _SetWheelScalarDart _setVehicleBrakeNative;
  late _VehicleUpdateDart _vehicleUpdateNative;
  late _GetWheelScalarDart _vehicleWheelRotationNative;
  late _GetWheelScalarDart _vehicleWheelSteeringNative;
  late _GetWheelScalarDart _vehicleWheelSuspensionLengthNative;
  late _GetWheelBoolDart _vehicleWheelIsInContactNative;
  late _GetWheelVec3Dart _vehicleWheelCenterNative;
  late _GetWheelVec3Dart _vehicleWheelContactPointNative;
  late _GetWheelVec3Dart _vehicleWheelContactNormalNative;
  late _GetVehicleScalarDart _vehicleCurrentSpeedNative;
  late _GetWheelGroundObjectDart _vehicleWheelGroundObjectNative;

  void initVehicleControllerBindings() {
    _createVehicleNative =
        dylib.lookupFunction<_CreateVehicleC, _CreateVehicleDart>("rapier_vehicle_create");
    _destroyVehicleNative =
        dylib.lookupFunction<_DestroyVehicleC, _DestroyVehicleDart>("rapier_vehicle_destroy");
    _addVehicleWheelNative =
        dylib.lookupFunction<_AddVehicleWheelC, _AddVehicleWheelDart>("rapier_vehicle_add_wheel");
    _vehicleWheelCountNative =
        dylib.lookupFunction<_WheelCountC, _WheelCountDart>("rapier_vehicle_wheel_count");
    _setVehicleSteeringNative =
        dylib.lookupFunction<_SetWheelScalarC, _SetWheelScalarDart>("rapier_vehicle_set_steering");
    _setVehicleEngineForceNative =
        dylib.lookupFunction<_SetWheelScalarC, _SetWheelScalarDart>("rapier_vehicle_set_engine_force");
    _setVehicleBrakeNative =
        dylib.lookupFunction<_SetWheelScalarC, _SetWheelScalarDart>("rapier_vehicle_set_brake");
    _vehicleUpdateNative =
        dylib.lookupFunction<_VehicleUpdateC, _VehicleUpdateDart>("rapier_vehicle_update");
    _vehicleWheelRotationNative =
        dylib.lookupFunction<_GetWheelScalarC, _GetWheelScalarDart>("rapier_vehicle_wheel_rotation");
    _vehicleWheelSteeringNative =
        dylib.lookupFunction<_GetWheelScalarC, _GetWheelScalarDart>("rapier_vehicle_wheel_steering");
    _vehicleWheelSuspensionLengthNative = dylib.lookupFunction<_GetWheelScalarC, _GetWheelScalarDart>(
        "rapier_vehicle_wheel_suspension_length");
    _vehicleWheelIsInContactNative =
        dylib.lookupFunction<_GetWheelBoolC, _GetWheelBoolDart>("rapier_vehicle_wheel_is_in_contact");
    _vehicleWheelCenterNative =
        dylib.lookupFunction<_GetWheelVec3C, _GetWheelVec3Dart>("rapier_vehicle_wheel_center");
    _vehicleWheelContactPointNative =
        dylib.lookupFunction<_GetWheelVec3C, _GetWheelVec3Dart>("rapier_vehicle_wheel_contact_point");
    _vehicleWheelContactNormalNative =
        dylib.lookupFunction<_GetWheelVec3C, _GetWheelVec3Dart>("rapier_vehicle_wheel_contact_normal");
    _vehicleCurrentSpeedNative =
        dylib.lookupFunction<_GetVehicleScalarC, _GetVehicleScalarDart>("rapier_vehicle_current_speed");
    _vehicleWheelGroundObjectNative = dylib
        .lookupFunction<_GetWheelGroundObjectC, _GetWheelGroundObjectDart>("rapier_vehicle_wheel_ground_object");
  }

  // ---- Public API ----------------------------------------------------------

  int createVehicle(int chassisHandle, int upAxis, int forwardAxis) =>
      _createVehicleNative(chassisHandle, upAxis, forwardAxis).address;

  void destroyVehicle(int vehicle) =>
      _destroyVehicleNative(Pointer<Void>.fromAddress(vehicle));

  int addVehicleWheel(
    int vehicle, {
    required double connectionX,
    required double connectionY,
    required double connectionZ,
    required double directionX,
    required double directionY,
    required double directionZ,
    required double axleX,
    required double axleY,
    required double axleZ,
    required double suspensionRestLength,
    required double radius,
    double suspensionStiffness = 0,
    double suspensionCompression = 0,
    double suspensionDamping = 0,
    double maxSuspensionTravel = 0,
    double frictionSlip = 0,
    double maxSuspensionForce = 0,
  }) =>
      _addVehicleWheelNative(
        Pointer<Void>.fromAddress(vehicle),
        connectionX, connectionY, connectionZ,
        directionX, directionY, directionZ,
        axleX, axleY, axleZ,
        suspensionRestLength, radius,
        suspensionStiffness, suspensionCompression, suspensionDamping,
        maxSuspensionTravel, frictionSlip, maxSuspensionForce,
      );

  int vehicleWheelCount(int vehicle) =>
      _vehicleWheelCountNative(Pointer<Void>.fromAddress(vehicle));

  void setVehicleSteering(int vehicle, int wheelIndex, double steering) =>
      _setVehicleSteeringNative(Pointer<Void>.fromAddress(vehicle), wheelIndex, steering);

  void setVehicleEngineForce(int vehicle, int wheelIndex, double force) =>
      _setVehicleEngineForceNative(Pointer<Void>.fromAddress(vehicle), wheelIndex, force);

  void setVehicleBrake(int vehicle, int wheelIndex, double brake) =>
      _setVehicleBrakeNative(Pointer<Void>.fromAddress(vehicle), wheelIndex, brake);

  void updateVehicle(int world, int vehicle, double dt) =>
      _vehicleUpdateNative(
          Pointer<Void>.fromAddress(world), Pointer<Void>.fromAddress(vehicle), dt);

  double vehicleWheelRotation(int vehicle, int wheelIndex) =>
      _vehicleWheelRotationNative(Pointer<Void>.fromAddress(vehicle), wheelIndex);

  double vehicleWheelSteering(int vehicle, int wheelIndex) =>
      _vehicleWheelSteeringNative(Pointer<Void>.fromAddress(vehicle), wheelIndex);

  double vehicleWheelSuspensionLength(int vehicle, int wheelIndex) =>
      _vehicleWheelSuspensionLengthNative(Pointer<Void>.fromAddress(vehicle), wheelIndex);

  bool vehicleWheelIsInContact(int vehicle, int wheelIndex) =>
      _vehicleWheelIsInContactNative(Pointer<Void>.fromAddress(vehicle), wheelIndex);

  Vector3 vehicleWheelCenter(int vehicle, int wheelIndex) {
    return using((arena) {
      final x = arena<Float>(), y = arena<Float>(), z = arena<Float>();
      _vehicleWheelCenterNative(Pointer<Void>.fromAddress(vehicle), wheelIndex, x, y, z);
      return Vector3(x.value, y.value, z.value);
    });
  }

  Vector3 vehicleWheelContactPoint(int vehicle, int wheelIndex) {
    return using((arena) {
      final x = arena<Float>(), y = arena<Float>(), z = arena<Float>();
      _vehicleWheelContactPointNative(Pointer<Void>.fromAddress(vehicle), wheelIndex, x, y, z);
      return Vector3(x.value, y.value, z.value);
    });
  }

  Vector3 vehicleWheelContactNormal(int vehicle, int wheelIndex) {
    return using((arena) {
      final x = arena<Float>(), y = arena<Float>(), z = arena<Float>();
      _vehicleWheelContactNormalNative(Pointer<Void>.fromAddress(vehicle), wheelIndex, x, y, z);
      return Vector3(x.value, y.value, z.value);
    });
  }

  double vehicleCurrentSpeed(int vehicle) =>
      _vehicleCurrentSpeedNative(Pointer<Void>.fromAddress(vehicle));

  /// Returns the collider handle of the ground object under a wheel,
  /// or -1 if not in contact.
  int vehicleWheelGroundObject(int vehicle, int wheelIndex) {
    final raw = _vehicleWheelGroundObjectNative(Pointer<Void>.fromAddress(vehicle), wheelIndex);
    return raw == 0xFFFFFFFF ? -1 : raw;
  }
}
