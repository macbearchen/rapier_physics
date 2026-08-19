part of 'rapier_bindings_impl.dart';

// ==========================================
// Native (C) Signatures
// (Shared: _WakeBodyC — declared in native_types.dart)
// ==========================================
typedef _CreateFixedJointC =
    Uint32 Function(
      Pointer<Void>,
      Uint32,
      Uint32,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
    );
typedef _CreateSphericalJointC =
    Uint32 Function(Pointer<Void>, Uint32, Uint32, Float, Float, Float, Float, Float, Float);
typedef _CreateRevoluteJointC =
    Uint32 Function(Pointer<Void>, Uint32, Uint32, Float, Float, Float, Float, Float, Float, Float, Float, Float);
typedef _CreatePrismaticJointC =
    Uint32 Function(Pointer<Void>, Uint32, Uint32, Float, Float, Float, Float, Float, Float, Float, Float, Float);
typedef _CreateGenericJointC = Uint32 Function(Pointer<Void>, Uint32, Uint32, Float, Float, Float, Float, Float, Float);
typedef _CreateRopeJointC =
    Uint32 Function(Pointer<Void>, Uint32, Uint32, Float, Float, Float, Float, Float, Float, Float);
typedef _LockAxisC = Void Function(Pointer<Void>, Uint32, Uint8, Bool);
typedef _SetLimitsC = Void Function(Pointer<Void>, Uint32, Uint8, Float, Float);
typedef _ConfigureMotorC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float);
typedef _ConfigureJointMotorC = Void Function(Pointer<Void>, Uint32, Uint8, Float, Float, Float, Float);

// ==========================================
// Dart Signatures
// ==========================================
typedef _CreateFixedJointDart =
    int Function(
      Pointer<Void>,
      int,
      int,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
    );
typedef _CreateSphericalJointDart =
    int Function(Pointer<Void>, int, int, double, double, double, double, double, double);
typedef _CreateRevoluteJointDart =
    int Function(Pointer<Void>, int, int, double, double, double, double, double, double, double, double, double);
typedef _CreatePrismaticJointDart =
    int Function(Pointer<Void>, int, int, double, double, double, double, double, double, double, double, double);
typedef _CreateGenericJointDart = int Function(Pointer<Void>, int, int, double, double, double, double, double, double);
typedef _CreateRopeJointDart =
    int Function(Pointer<Void>, int, int, double, double, double, double, double, double, double);
typedef _LockAxisDart = void Function(Pointer<Void>, int, int, bool);
typedef _SetLimitsDart = void Function(Pointer<Void>, int, int, double, double);
typedef _ConfigureMotorDart = void Function(Pointer<Void>, int, double, double, double, double);
typedef _ConfigureJointMotorDart = void Function(Pointer<Void>, int, int, double, double, double, double);

/// FFI bindings for all `Joint` types (fixed, spherical, revolute, prismatic,
/// generic, rope), plus axis locking, limits, and motor configuration.
mixin JointBindings on FfiBindingsBase {
  late _CreateFixedJointDart _createFixedJointNative;
  late _CreateSphericalJointDart _createSphericalJointNative;
  late _CreateRevoluteJointDart _createRevoluteJointNative;
  late _CreatePrismaticJointDart _createPrismaticJointNative;
  late _CreateGenericJointDart _createGenericJointNative;
  late _CreateRopeJointDart _createRopeJointNative;
  late _WakeBodyDart _removeJointNative;
  late _LockAxisDart _lockAxisNative;
  late _SetLimitsDart _setLimitsNative;
  late _ConfigureJointMotorDart _configureJointMotorNative;
  late _ConfigureMotorDart _configureRevoluteMotorNative;
  late _ConfigureMotorDart _configurePrismaticMotorNative;

  void initJointBindings() {
    _createFixedJointNative =
        dylib.lookupFunction<_CreateFixedJointC, _CreateFixedJointDart>('rapier_joint_create_fixed');
    _createSphericalJointNative =
        dylib.lookupFunction<_CreateSphericalJointC, _CreateSphericalJointDart>('rapier_joint_create_spherical');
    _createRevoluteJointNative =
        dylib.lookupFunction<_CreateRevoluteJointC, _CreateRevoluteJointDart>('rapier_joint_create_revolute');
    _createPrismaticJointNative =
        dylib.lookupFunction<_CreatePrismaticJointC, _CreatePrismaticJointDart>('rapier_joint_create_prismatic');
    _createGenericJointNative =
        dylib.lookupFunction<_CreateGenericJointC, _CreateGenericJointDart>('rapier_joint_create_generic');
    _createRopeJointNative = dylib.lookupFunction<_CreateRopeJointC, _CreateRopeJointDart>('rapier_joint_create_rope');
    _removeJointNative = dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_joint_remove');
    _lockAxisNative = dylib.lookupFunction<_LockAxisC, _LockAxisDart>('rapier_joint_lock_axis');
    _setLimitsNative = dylib.lookupFunction<_SetLimitsC, _SetLimitsDart>('rapier_joint_set_limits');
    _configureJointMotorNative =
        dylib.lookupFunction<_ConfigureJointMotorC, _ConfigureJointMotorDart>('rapier_joint_configure_motor');
    _configureRevoluteMotorNative = dylib
        .lookupFunction<_ConfigureMotorC, _ConfigureMotorDart>('rapier_joint_configure_revolute_motor');
    _configurePrismaticMotorNative = dylib
        .lookupFunction<_ConfigureMotorC, _ConfigureMotorDart>('rapier_joint_configure_prismatic_motor');
  }

  int createFixedJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double r1x,
    double r1y,
    double r1z,
    double r1w,
    double a2x,
    double a2y,
    double a2z,
    double r2x,
    double r2y,
    double r2z,
    double r2w,
  ) => _createFixedJointNative(
    Pointer<Void>.fromAddress(world),
    body1,
    body2,
    a1x,
    a1y,
    a1z,
    r1x,
    r1y,
    r1z,
    r1w,
    a2x,
    a2y,
    a2z,
    r2x,
    r2y,
    r2z,
    r2w,
  );

  int createSphericalJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => _createSphericalJointNative(Pointer<Void>.fromAddress(world), body1, body2, a1x, a1y, a1z, a2x, a2y, a2z);

  int createRevoluteJoint(
    int world,
    int body1,
    int body2,
    double vx,
    double vy,
    double vz,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => _createRevoluteJointNative(
    Pointer<Void>.fromAddress(world),
    body1,
    body2,
    vx,
    vy,
    vz,
    a1x,
    a1y,
    a1z,
    a2x,
    a2y,
    a2z,
  );

  int createPrismaticJoint(
    int world,
    int body1,
    int body2,
    double vx,
    double vy,
    double vz,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => _createPrismaticJointNative(
    Pointer<Void>.fromAddress(world),
    body1,
    body2,
    vx,
    vy,
    vz,
    a1x,
    a1y,
    a1z,
    a2x,
    a2y,
    a2z,
  );

  int createGenericJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => _createGenericJointNative(Pointer<Void>.fromAddress(world), body1, body2, a1x, a1y, a1z, a2x, a2y, a2z);

  int createRopeJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
    double maxDist,
  ) => _createRopeJointNative(Pointer<Void>.fromAddress(world), body1, body2, a1x, a1y, a1z, a2x, a2y, a2z, maxDist);

  void removeJoint(int world, int handle) => _removeJointNative(Pointer<Void>.fromAddress(world), handle);

  void lockJointAxis(int world, int joint, int axis, bool locked) =>
      _lockAxisNative(Pointer<Void>.fromAddress(world), joint, axis, locked);

  void setJointLimits(int world, int joint, int axis, double min, double max) =>
      _setLimitsNative(Pointer<Void>.fromAddress(world), joint, axis, min, max);

  void configureJointMotor(
    int world,
    int joint,
    int axis,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => _configureJointMotorNative(
    Pointer<Void>.fromAddress(world),
    joint,
    axis,
    targetPos,
    targetVel,
    stiffness,
    damping,
  );

  void configureRevoluteJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => _configureRevoluteMotorNative(Pointer<Void>.fromAddress(world), joint, targetPos, targetVel, stiffness, damping);

  void configurePrismaticJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) =>
      _configurePrismaticMotorNative(Pointer<Void>.fromAddress(world), joint, targetPos, targetVel, stiffness, damping);
}
