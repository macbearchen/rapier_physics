part of 'rapier_bindings_impl.dart';

// ==========================================
// Native (C) Signatures
// (Shared: _WakeBodyC, _GetVec3C, _GetQuatC — declared in native_types.dart)
// ==========================================
typedef _CreateRigidBodyC = Uint32 Function(Pointer<Void>, Float, Float, Float, Uint8);
typedef _SetPositionC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _SetRotationC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float);
typedef _SetCCDC = Void Function(Pointer<Void>, Uint32, Bool);
typedef _SetBodyDampingC = Void Function(Pointer<Void>, Uint32, Float);
typedef _BodyForceC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _BodyForceAtPointC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float, Float, Float);

// ==========================================
// Dart Signatures
// (Shared: _WakeBodyDart, _GetVec3Dart, _GetQuatDart — declared in native_types.dart)
// ==========================================
typedef _CreateRigidBodyDart = int Function(Pointer<Void>, double, double, double, int);
typedef _SetPositionDart = void Function(Pointer<Void>, int, double, double, double);
typedef _SetRotationDart = void Function(Pointer<Void>, int, double, double, double, double);
typedef _SetCCDDart = void Function(Pointer<Void>, int, bool);
typedef _SetBodyDampingDart = void Function(Pointer<Void>, int, double);
typedef _BodyForceDart = void Function(Pointer<Void>, int, double, double, double);
typedef _BodyForceAtPointDart = void Function(Pointer<Void>, int, double, double, double, double, double, double);

/// FFI bindings for `RigidBody`: creation/removal, transform, damping,
/// CCD, forces/torques/impulses, and velocities.
mixin RigidBodyBindings on FfiBindingsBase {
  late _CreateRigidBodyDart _createRigidBodyNative;
  late _WakeBodyDart _removeRigidBodyNative;
  late _GetVec3Dart _getBodyPositionNative;
  late _GetQuatDart _getBodyRotationNative;
  late _SetPositionDart _setPositionNative;
  late _SetRotationDart _setRotationNative;
  late _WakeBodyDart _wakeBodyNative;
  late _SetCCDDart _setCCDNative;
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

  void initRigidBodyBindings() {
    _createRigidBodyNative = dylib.lookupFunction<_CreateRigidBodyC, _CreateRigidBodyDart>('rapier_rigid_body_create');
    _removeRigidBodyNative = dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_rigid_body_remove');
    _getBodyPositionNative = dylib.lookupFunction<_GetVec3C, _GetVec3Dart>('rapier_rigid_body_get_position');
    _getBodyRotationNative = dylib.lookupFunction<_GetQuatC, _GetQuatDart>('rapier_rigid_body_get_rotation');
    _setPositionNative = dylib.lookupFunction<_SetPositionC, _SetPositionDart>('rapier_rigid_body_set_position');
    _setRotationNative = dylib.lookupFunction<_SetRotationC, _SetRotationDart>('rapier_rigid_body_set_rotation');
    _wakeBodyNative = dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_rigid_body_wake');
    _setCCDNative = dylib.lookupFunction<_SetCCDC, _SetCCDDart>('rapier_rigid_body_set_ccd');
    _setBodyLinearDampingNative =
        dylib.lookupFunction<_SetBodyDampingC, _SetBodyDampingDart>('rapier_rigid_body_set_linear_damping');
    _setBodyAngularDampingNative =
        dylib.lookupFunction<_SetBodyDampingC, _SetBodyDampingDart>('rapier_rigid_body_set_angular_damping');
    _addForceNative = dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_rigid_body_add_force');
    _addTorqueNative = dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_rigid_body_add_torque');
    _applyImpulseNative = dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_rigid_body_apply_impulse');
    _applyTorqueImpulseNative =
        dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_rigid_body_apply_torque_impulse');
    _addForceAtPointNative =
        dylib.lookupFunction<_BodyForceAtPointC, _BodyForceAtPointDart>('rapier_rigid_body_add_force_at_point');
    _applyImpulseAtPointNative = dylib
        .lookupFunction<_BodyForceAtPointC, _BodyForceAtPointDart>('rapier_rigid_body_apply_impulse_at_point');
    _setLinearVelocityNative =
        dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_rigid_body_set_linear_velocity');
    _setAngularVelocityNative =
        dylib.lookupFunction<_BodyForceC, _BodyForceDart>('rapier_rigid_body_set_angular_velocity');
  }

  int createRigidBody(int world, RigidBodyDesc desc) {
    final handle = _createRigidBodyNative(
      Pointer<Void>.fromAddress(world),
      desc.position.x,
      desc.position.y,
      desc.position.z,
      desc.type.index,
    );

    if (desc.rotation != Quaternion.identity()) {
      setBodyRotation(world, handle, desc.rotation.x, desc.rotation.y, desc.rotation.z, desc.rotation.w);
    }
    if (desc.linearVelocity != Vector3.zero()) {
      setBodyLinearVelocity(world, handle, desc.linearVelocity.x, desc.linearVelocity.y, desc.linearVelocity.z);
    }
    if (desc.angularVelocity != Vector3.zero()) {
      setBodyAngularVelocity(world, handle, desc.angularVelocity.x, desc.angularVelocity.y, desc.angularVelocity.z);
    }
    if (desc.linearDamping != 0.0) {
      setBodyLinearDamping(world, handle, desc.linearDamping);
    }
    if (desc.angularDamping != 0.0) {
      setBodyAngularDamping(world, handle, desc.angularDamping);
    }
    if (desc.ccdEnabled) {
      setBodyCCD(world, handle, true);
    }

    return handle;
  }

  void removeRigidBody(int world, int handle) => _removeRigidBodyNative(Pointer<Void>.fromAddress(world), handle);

  Vector3 getBodyPosition(int world, int body) {
    final handle = Pointer<Void>.fromAddress(world);
    final pos = _getBodyPositionNative(handle, body);
    return Vector3(pos.x, pos.y, pos.z);
  }

  Quaternion getBodyRotation(int world, int body) {
    final handle = Pointer<Void>.fromAddress(world);
    final rot = _getBodyRotationNative(handle, body);
    return Quaternion(rot.x, rot.y, rot.z, rot.w);
  }

  void setBodyPosition(int world, int body, double x, double y, double z) =>
      _setPositionNative(Pointer<Void>.fromAddress(world), body, x, y, z);

  void setBodyRotation(int world, int body, double x, double y, double z, double w) =>
      _setRotationNative(Pointer<Void>.fromAddress(world), body, x, y, z, w);

  void setBodyLinearDamping(int world, int handle, double damping) =>
      _setBodyLinearDampingNative(Pointer<Void>.fromAddress(world), handle, damping);

  void setBodyAngularDamping(int world, int handle, double damping) =>
      _setBodyAngularDampingNative(Pointer<Void>.fromAddress(world), handle, damping);

  void setBodyCCD(int world, int body, bool enabled) => _setCCDNative(Pointer<Void>.fromAddress(world), body, enabled);

  void wakeBody(int world, int body) => _wakeBodyNative(Pointer<Void>.fromAddress(world), body);

  void addForce(int world, int handle, double x, double y, double z) =>
      _addForceNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  void addTorque(int world, int handle, double x, double y, double z) =>
      _addTorqueNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  void applyImpulse(int world, int handle, double x, double y, double z) =>
      _applyImpulseNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  void applyTorqueImpulse(int world, int handle, double x, double y, double z) =>
      _applyTorqueImpulseNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  void addForceAtPoint(int world, int handle, double fx, double fy, double fz, double px, double py, double pz) =>
      _addForceAtPointNative(Pointer<Void>.fromAddress(world), handle, fx, fy, fz, px, py, pz);

  void applyImpulseAtPoint(int world, int handle, double ix, double iy, double iz, double px, double py, double pz) =>
      _applyImpulseAtPointNative(Pointer<Void>.fromAddress(world), handle, ix, iy, iz, px, py, pz);

  void setBodyLinearVelocity(int world, int handle, double x, double y, double z) =>
      _setLinearVelocityNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  void setBodyAngularVelocity(int world, int handle, double x, double y, double z) =>
      _setAngularVelocityNative(Pointer<Void>.fromAddress(world), handle, x, y, z);
}
