import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_type.dart';
import 'rapier_bindings.dart';

// Native (C) signatures
typedef _CreateWorldC = Pointer<Void> Function();
typedef _VersionC = Pointer<Utf8> Function();
typedef _DestroyWorldC = Void Function(Pointer<Void>);
typedef _StepWorldC = Void Function(Pointer<Void>);
typedef _CreateRigidBodyC = Uint32 Function(Pointer<Void>, Float, Float, Float, Uint8);
typedef _CreateBoxColliderC = Uint32 Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _CreateSphereColliderC = Uint32 Function(Pointer<Void>, Uint32, Float);
typedef _CreateCylinderColliderC = Uint32 Function(Pointer<Void>, Uint32, Float, Float);
typedef _CreateConeColliderC = Uint32 Function(Pointer<Void>, Uint32, Float, Float);
typedef _CreateCapsuleColliderC = Uint32 Function(Pointer<Void>, Uint32, Float, Float);
typedef _CreateHeightfieldColliderC =
    Uint32 Function(Pointer<Void>, Uint32, Pointer<Float>, Size, Size, Float, Float, Float);
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
typedef _GetFloatC = Float Function(Pointer<Void>, Uint32);
typedef _SetPositionC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _SetRotationC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float);
typedef _SetGravityC = Void Function(Pointer<Void>, Float, Float, Float);
typedef _WakeBodyC = Void Function(Pointer<Void>, Uint32);
typedef _SetCCDC = Void Function(Pointer<Void>, Uint32, Bool);
typedef _SetColliderFrictionC = Void Function(Pointer<Void>, Uint32, Float);
typedef _SetColliderRestitutionC = Void Function(Pointer<Void>, Uint32, Float);
typedef _SetColliderDensityC = Void Function(Pointer<Void>, Uint32, Float);
typedef _SetBodyDampingC = Void Function(Pointer<Void>, Uint32, Float);
typedef _BodyForceC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _BodyForceAtPointC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float, Float, Float);

// Dart-side equivalents
typedef _CreateWorldDart = Pointer<Void> Function();
typedef _VersionDart = Pointer<Utf8> Function();
typedef _DestroyWorldDart = void Function(Pointer<Void>);
typedef _StepWorldDart = void Function(Pointer<Void>);
typedef _CreateRigidBodyDart = int Function(Pointer<Void>, double, double, double, int);
typedef _CreateBoxColliderDart = int Function(Pointer<Void>, int, double, double, double);
typedef _CreateSphereColliderDart = int Function(Pointer<Void>, int, double);
typedef _CreateCylinderColliderDart = int Function(Pointer<Void>, int, double, double);
typedef _CreateConeColliderDart = int Function(Pointer<Void>, int, double, double);
typedef _CreateCapsuleColliderDart = int Function(Pointer<Void>, int, double, double);
typedef _CreateHeightfieldColliderDart =
    int Function(Pointer<Void>, int, Pointer<Float>, int, int, double, double, double);
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
typedef _GetFloatDart = double Function(Pointer<Void>, int);
typedef _SetPositionDart = void Function(Pointer<Void>, int, double, double, double);
typedef _SetRotationDart = void Function(Pointer<Void>, int, double, double, double, double);
typedef _SetGravityDart = void Function(Pointer<Void>, double, double, double);
typedef _WakeBodyDart = void Function(Pointer<Void>, int);
typedef _SetCCDDart = void Function(Pointer<Void>, int, bool);
typedef _SetColliderFrictionDart = void Function(Pointer<Void>, int, double);
typedef _SetColliderRestitutionDart = void Function(Pointer<Void>, int, double);
typedef _SetColliderDensityDart = void Function(Pointer<Void>, int, double);
typedef _SetBodyDampingDart = void Function(Pointer<Void>, int, double);
typedef _BodyForceDart = void Function(Pointer<Void>, int, double, double, double);
typedef _BodyForceAtPointDart = void Function(Pointer<Void>, int, double, double, double, double, double, double);

class RapierBindingsImpl extends RapierBindings {
  late DynamicLibrary _dylib;

  late _VersionDart _versionNative;
  late _CreateWorldDart _createWorldNative;
  late _DestroyWorldDart _destroyWorldNative;
  late _SetGravityDart _setGravityNative;
  late _StepWorldDart _stepWorldNative;
  late _CreateRigidBodyDart _createRigidBodyNative;
  late _CreateBoxColliderDart _createBoxColliderNative;
  late _CreateSphereColliderDart _createSphereColliderNative;
  late _CreateCylinderColliderDart _createCylinderColliderNative;
  late _CreateConeColliderDart _createConeColliderNative;
  late _CreateCapsuleColliderDart _createCapsuleColliderNative;
  late _CreateHeightfieldColliderDart _createHeightfieldColliderNative;

  late _CreateFixedJointDart _createFixedJointNative;
  late _CreateSphericalJointDart _createSphericalJointNative;
  late _CreateRevoluteJointDart _createRevoluteJointNative;
  late _CreatePrismaticJointDart _createPrismaticJointNative;
  late _CreateGenericJointDart _createGenericJointNative;
  late _CreateRopeJointDart _createRopeJointNative;
  late _LockAxisDart _lockAxisNative;
  late _SetLimitsDart _setLimitsNative;
  late _ConfigureJointMotorDart _configureJointMotorNative;
  late _ConfigureMotorDart _configureRevoluteMotorNative;
  late _ConfigureMotorDart _configurePrismaticMotorNative;

  late _GetFloatDart _getPosX;
  late _GetFloatDart _getPosY;
  late _GetFloatDart _getPosZ;
  late _GetFloatDart _getRotX;
  late _GetFloatDart _getRotY;
  late _GetFloatDart _getRotZ;
  late _GetFloatDart _getRotW;

  late _SetPositionDart _setPositionNative;
  late _SetRotationDart _setRotationNative;
  late _WakeBodyDart _wakeBodyNative;
  late _SetCCDDart _setCCDNative;
  late _SetColliderFrictionDart _setColliderFrictionNative;
  late _SetColliderRestitutionDart _setColliderRestitutionNative;
  late _SetColliderDensityDart _setColliderDensityNative;
  late _SetBodyDampingDart _setBodyLinearDampingNative;
  late _SetBodyDampingDart _setBodyAngularDampingNative;

  late _BodyForceDart _addForceNative;
  late _BodyForceDart _addTorqueNative;
  late _BodyForceDart _applyImpulseNative;
  late _BodyForceDart _applyTorqueImpulseNative;
  late _BodyForceAtPointDart _addForceAtPointNative;
  late _BodyForceAtPointDart _applyImpulseAtPointNative;
  late _BodyForceDart _setLinearVelocityNative;
  late _BodyForceDart _setAngularVelocityNative;
  late _WakeBodyDart _removeRigidBodyNative;
  late _WakeBodyDart _removeColliderNative;
  late _WakeBodyDart _removeJointNative;

  @override
  Future<void> init() async {
    if (Platform.isMacOS || Platform.isIOS) {
      _dylib = DynamicLibrary.process();
    } else if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('prebuilt/rapier_ffi.dll');
    } else if (Platform.isLinux) {
      _dylib = DynamicLibrary.open('prebuilt/librapier_ffi.so');
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('librapier_ffi.so');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    _versionNative = _dylib.lookupFunction<_VersionC, _VersionDart>('rapier_version');
    _createWorldNative = _dylib.lookupFunction<_CreateWorldC, _CreateWorldDart>('rapier_world_create');
    _destroyWorldNative = _dylib.lookupFunction<_DestroyWorldC, _DestroyWorldDart>('rapier_world_destroy');
    _setGravityNative = _dylib.lookupFunction<_SetGravityC, _SetGravityDart>('rapier_world_set_gravity');
    _stepWorldNative = _dylib.lookupFunction<_StepWorldC, _StepWorldDart>('rapier_world_step');
    _createRigidBodyNative = _dylib.lookupFunction<_CreateRigidBodyC, _CreateRigidBodyDart>('rapier_create_rigid_body');
    _createBoxColliderNative = _dylib.lookupFunction<_CreateBoxColliderC, _CreateBoxColliderDart>(
      'rapier_create_box_collider',
    );
    _createSphereColliderNative = _dylib.lookupFunction<_CreateSphereColliderC, _CreateSphereColliderDart>(
      'rapier_create_sphere_collider',
    );
    _createCylinderColliderNative = _dylib.lookupFunction<_CreateCylinderColliderC, _CreateCylinderColliderDart>(
      'rapier_create_cylinder_collider',
    );
    _createConeColliderNative = _dylib.lookupFunction<_CreateConeColliderC, _CreateConeColliderDart>(
      'rapier_create_cone_collider',
    );
    _createCapsuleColliderNative = _dylib.lookupFunction<_CreateCapsuleColliderC, _CreateCapsuleColliderDart>(
      'rapier_create_capsule_collider',
    );
    _createHeightfieldColliderNative = _dylib
        .lookupFunction<_CreateHeightfieldColliderC, _CreateHeightfieldColliderDart>(
          'rapier_create_heightfield_collider',
        );

    _createFixedJointNative = _dylib.lookupFunction<_CreateFixedJointC, _CreateFixedJointDart>(
      'rapier_create_fixed_joint',
    );
    _createSphericalJointNative = _dylib.lookupFunction<_CreateSphericalJointC, _CreateSphericalJointDart>(
      'rapier_create_spherical_joint',
    );
    _createRevoluteJointNative = _dylib.lookupFunction<_CreateRevoluteJointC, _CreateRevoluteJointDart>(
      'rapier_create_revolute_joint',
    );
    _createPrismaticJointNative = _dylib.lookupFunction<_CreatePrismaticJointC, _CreatePrismaticJointDart>(
      'rapier_create_prismatic_joint',
    );
    _createGenericJointNative = _dylib.lookupFunction<_CreateGenericJointC, _CreateGenericJointDart>(
      'rapier_create_generic_joint',
    );
    _createRopeJointNative = _dylib.lookupFunction<_CreateRopeJointC, _CreateRopeJointDart>('rapier_create_rope_joint');
    _lockAxisNative = _dylib.lookupFunction<_LockAxisC, _LockAxisDart>('rapier_joint_lock_axis');
    _setLimitsNative = _dylib.lookupFunction<_SetLimitsC, _SetLimitsDart>('rapier_joint_set_limits');
    _configureJointMotorNative = _dylib.lookupFunction<_ConfigureJointMotorC, _ConfigureJointMotorDart>(
      'rapier_joint_configure_motor',
    );
    _configureRevoluteMotorNative = _dylib.lookupFunction<_ConfigureMotorC, _ConfigureMotorDart>(
      'rapier_joint_configure_revolute_motor',
    );
    _configurePrismaticMotorNative = _dylib.lookupFunction<_ConfigureMotorC, _ConfigureMotorDart>(
      'rapier_joint_configure_prismatic_motor',
    );

    _getPosX = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_position_x');
    _getPosY = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_position_y');
    _getPosZ = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_position_z');
    _getRotX = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_x');
    _getRotY = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_y');
    _getRotZ = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_z');
    _getRotW = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_w');

    _setPositionNative = _dylib.lookupFunction<_SetPositionC, _SetPositionDart>('rapier_set_body_position');
    _setRotationNative = _dylib.lookupFunction<_SetRotationC, _SetRotationDart>('rapier_set_body_rotation');
    _wakeBodyNative = _dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_wake_body');
    _setCCDNative = _dylib.lookupFunction<_SetCCDC, _SetCCDDart>('rapier_set_body_ccd');
    _setColliderFrictionNative = _dylib.lookupFunction<_SetColliderFrictionC, _SetColliderFrictionDart>(
      'rapier_set_collider_friction',
    );
    _setColliderRestitutionNative = _dylib.lookupFunction<_SetColliderRestitutionC, _SetColliderRestitutionDart>(
      'rapier_set_collider_restitution',
    );
    _setColliderDensityNative = _dylib.lookupFunction<_SetColliderDensityC, _SetColliderDensityDart>(
      'rapier_set_collider_density',
    );
    _setBodyLinearDampingNative = _dylib.lookupFunction<_SetBodyDampingC, _SetBodyDampingDart>(
      'rapier_set_body_linear_damping',
    );
    _setBodyAngularDampingNative = _dylib.lookupFunction<_SetBodyDampingC, _SetBodyDampingDart>(
      'rapier_set_body_angular_damping',
    );
    _addForceNative = _dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_body_add_force');
    _addTorqueNative = _dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_body_add_torque');
    _applyImpulseNative = _dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_body_apply_impulse');
    _applyTorqueImpulseNative = _dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_body_apply_torque_impulse');
    _addForceAtPointNative = _dylib.lookupFunction<_BodyForceAtPointC, _BodyForceAtPointDart>(
      'rapier_body_add_force_at_point',
    );
    _applyImpulseAtPointNative = _dylib.lookupFunction<_BodyForceAtPointC, _BodyForceAtPointDart>(
      'rapier_body_apply_impulse_at_point',
    );
    _setLinearVelocityNative = _dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_body_set_linear_velocity');
    _setAngularVelocityNative = _dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_body_set_angular_velocity');
    _removeRigidBodyNative = _dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_world_remove_rigid_body');
    _removeColliderNative = _dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_world_remove_collider');
    _removeJointNative = _dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_world_remove_joint');
  }

  @override
  String getVersion() => _versionNative().toDartString();

  @override
  int createWorld() => _createWorldNative().address;

  @override
  void setGravity(int world, double x, double y, double z) =>
      _setGravityNative(Pointer<Void>.fromAddress(world), x, y, z);

  @override
  void destroyWorld(int world) => _destroyWorldNative(Pointer<Void>.fromAddress(world));

  @override
  void stepWorld(int world) => _stepWorldNative(Pointer<Void>.fromAddress(world));

  @override
  int createRigidBody(int world, double x, double y, double z, RigidBodyType type) =>
      _createRigidBodyNative(Pointer<Void>.fromAddress(world), x, y, z, type.index);

  @override
  int createBoxCollider(int world, int body, double hx, double hy, double hz) =>
      _createBoxColliderNative(Pointer<Void>.fromAddress(world), body, hx, hy, hz);

  @override
  int createSphereCollider(int world, int body, double radius) =>
      _createSphereColliderNative(Pointer<Void>.fromAddress(world), body, radius);

  @override
  int createCylinderCollider(int world, int body, double halfHeight, double radius) =>
      _createCylinderColliderNative(Pointer<Void>.fromAddress(world), body, halfHeight, radius);

  @override
  int createConeCollider(int world, int body, double halfHeight, double radius) =>
      _createConeColliderNative(Pointer<Void>.fromAddress(world), body, halfHeight, radius);

  @override
  int createCapsuleCollider(int world, int body, double halfHeight, double radius) =>
      _createCapsuleColliderNative(Pointer<Void>.fromAddress(world), body, halfHeight, radius);

  @override
  int createHeightfieldCollider(
    int world,
    int body,
    Float32List heights,
    int nrows,
    int ncols,
    double sx,
    double sy,
    double sz,
  ) {
    final pointer = calloc<Float>(heights.length);
    pointer.asTypedList(heights.length).setAll(0, heights);
    final handle = _createHeightfieldColliderNative(
      Pointer<Void>.fromAddress(world),
      body,
      pointer,
      nrows,
      ncols,
      sx,
      sy,
      sz,
    );
    calloc.free(pointer);
    return handle;
  }

  @override
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

  @override
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

  @override
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

  @override
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

  @override
  void configureRevoluteJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => _configureRevoluteMotorNative(Pointer<Void>.fromAddress(world), joint, targetPos, targetVel, stiffness, damping);

  @override
  void configurePrismaticJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) =>
      _configurePrismaticMotorNative(Pointer<Void>.fromAddress(world), joint, targetPos, targetVel, stiffness, damping);

  @override
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

  @override
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

  @override
  void lockJointAxis(int world, int joint, int axis, bool locked) =>
      _lockAxisNative(Pointer<Void>.fromAddress(world), joint, axis, locked);

  @override
  void setJointLimits(int world, int joint, int axis, double min, double max) =>
      _setLimitsNative(Pointer<Void>.fromAddress(world), joint, axis, min, max);

  @override
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

  @override
  Vector3 getBodyPosition(int world, int body) {
    final handle = Pointer<Void>.fromAddress(world);
    return Vector3(_getPosX(handle, body), _getPosY(handle, body), _getPosZ(handle, body));
  }

  @override
  Quaternion getBodyRotation(int world, int body) {
    final handle = Pointer<Void>.fromAddress(world);
    return Quaternion(_getRotX(handle, body), _getRotY(handle, body), _getRotZ(handle, body), _getRotW(handle, body));
  }

  @override
  void setBodyPosition(int world, int body, double x, double y, double z) =>
      _setPositionNative(Pointer<Void>.fromAddress(world), body, x, y, z);

  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) =>
      _setRotationNative(Pointer<Void>.fromAddress(world), body, x, y, z, w);

  @override
  void setBodyCCD(int world, int body, bool enabled) => _setCCDNative(Pointer<Void>.fromAddress(world), body, enabled);

  @override
  void wakeBody(int world, int body) => _wakeBodyNative(Pointer<Void>.fromAddress(world), body);

  @override
  void setColliderFriction(int world, int handle, double friction) =>
      _setColliderFrictionNative(Pointer<Void>.fromAddress(world), handle, friction);

  @override
  void setColliderRestitution(int world, int handle, double restitution) =>
      _setColliderRestitutionNative(Pointer<Void>.fromAddress(world), handle, restitution);

  @override
  void setColliderDensity(int world, int handle, double density) =>
      _setColliderDensityNative(Pointer<Void>.fromAddress(world), handle, density);

  @override
  void setBodyLinearDamping(int world, int handle, double damping) =>
      _setBodyLinearDampingNative(Pointer<Void>.fromAddress(world), handle, damping);

  @override
  void setBodyAngularDamping(int world, int handle, double damping) =>
      _setBodyAngularDampingNative(Pointer<Void>.fromAddress(world), handle, damping);

  @override
  void addForce(int world, int handle, double x, double y, double z) =>
      _addForceNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  @override
  void addTorque(int world, int handle, double x, double y, double z) =>
      _addTorqueNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  @override
  void applyImpulse(int world, int handle, double x, double y, double z) =>
      _applyImpulseNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  @override
  void applyTorqueImpulse(int world, int handle, double x, double y, double z) =>
      _applyTorqueImpulseNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  @override
  void addForceAtPoint(int world, int handle, double fx, double fy, double fz, double px, double py, double pz) =>
      _addForceAtPointNative(Pointer<Void>.fromAddress(world), handle, fx, fy, fz, px, py, pz);

  @override
  void applyImpulseAtPoint(int world, int handle, double ix, double iy, double iz, double px, double py, double pz) =>
      _applyImpulseAtPointNative(Pointer<Void>.fromAddress(world), handle, ix, iy, iz, px, py, pz);

  @override
  void setBodyLinearVelocity(int world, int handle, double x, double y, double z) =>
      _setLinearVelocityNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  @override
  void setBodyAngularVelocity(int world, int handle, double x, double y, double z) =>
      _setAngularVelocityNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  @override
  void removeRigidBody(int world, int handle) =>
      _removeRigidBodyNative(Pointer<Void>.fromAddress(world), handle);

  @override
  void removeCollider(int world, int handle) =>
      _removeColliderNative(Pointer<Void>.fromAddress(world), handle);

  @override
  void removeJoint(int world, int handle) => _removeJointNative(Pointer<Void>.fromAddress(world), handle);
}
