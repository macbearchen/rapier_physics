import 'bindings/rapier_bindings.dart';
import 'bindings/rapier_bindings_stub.dart'
    if (dart.library.ffi) 'bindings/rapier_bindings_ffi.dart'
    if (dart.library.js_interop) 'bindings/rapier_bindings_web.dart' as bindings;

import 'package:vector_math/vector_math.dart';
export 'package:vector_math/vector_math.dart' show Vector3, Quaternion;
import 'rigid_body.dart';
import 'collider.dart';
import 'rigid_body_type.dart';

class RapierWorld {
  late RapierBindings _bindings;
  int _worldHandle = 0;

  RapierWorld() {
    _bindings = bindings.RapierBindingsImpl();
  }

  Future<void> init({Vector3? gravity}) async {
    await _bindings.init();
    _worldHandle = _bindings.createWorld();
    if (gravity != null) {
      setGravity(gravity.x, gravity.y, gravity.z);
    }
  }

  void setGravity(double x, double y, double z) {
    if (_worldHandle != 0) {
      _bindings.setGravity(_worldHandle, x, y, z);
    }
  }

  String get version => _bindings.getVersion();

  void step() {
    if (_worldHandle != 0) {
      _bindings.stepWorld(_worldHandle);
    }
  }

  Vector3 getBodyPosition(int bodyHandle) {
    return _bindings.getBodyPosition(_worldHandle, bodyHandle);
  }

  Quaternion getBodyRotation(int bodyHandle) {
    return _bindings.getBodyRotation(_worldHandle, bodyHandle);
  }

  void setBodyPosition(int bodyHandle, double x, double y, double z) {
    _bindings.setBodyPosition(_worldHandle, bodyHandle, x, y, z);
  }

  void setBodyRotation(int bodyHandle, double x, double y, double z, double w) {
    _bindings.setBodyRotation(_worldHandle, bodyHandle, x, y, z, w);
  }

  RigidBody createRigidBody(double x, double y, double z, {RigidBodyType type = RigidBodyType.dynamic}) {
    final handle = createRigidBodyHandle(x, y, z, type: type);
    return RigidBody(handle, this);
  }

  int createRigidBodyHandle(double x, double y, double z, {RigidBodyType type = RigidBodyType.dynamic}) {
    return _bindings.createRigidBody(_worldHandle, x, y, z, type);
  }

  RigidBody addBox({
    required double x,
    required double y,
    required double z,
    required double hx,
    required double hy,
    required double hz,
    RigidBodyType type = RigidBodyType.dynamic,
  }) {
    final body = createRigidBody(x, y, z, type: type);
    createBoxCollider(body, hx, hy, hz);
    return body;
  }

  RigidBody addSphere({
    required double x,
    required double y,
    required double z,
    required double radius,
    RigidBodyType type = RigidBodyType.dynamic,
  }) {
    final body = createRigidBody(x, y, z, type: type);
    createSphereCollider(body, radius);
    return body;
  }

  RigidBody addCylinder({
    required double x,
    required double y,
    required double z,
    required double halfHeight,
    required double radius,
    RigidBodyType type = RigidBodyType.dynamic,
  }) {
    final body = createRigidBody(x, y, z, type: type);
    createCylinderCollider(body, halfHeight, radius);
    return body;
  }

  RigidBody addCapsule({
    required double x,
    required double y,
    required double z,
    required double halfHeight,
    required double radius,
    RigidBodyType type = RigidBodyType.dynamic,
  }) {
    final body = createRigidBody(x, y, z, type: type);
    createCapsuleCollider(body, halfHeight, radius);
    return body;
  }

  Collider createBoxCollider(RigidBody body, double hx, double hy, double hz) {
    _bindings.createBoxCollider(_worldHandle, body.handle, hx, hy, hz);
    return Collider(body);
  }

  Collider createSphereCollider(RigidBody body, double radius) {
    _bindings.createSphereCollider(_worldHandle, body.handle, radius);
    return Collider(body);
  }

  Collider createCylinderCollider(RigidBody body, double halfHeight, double radius) {
    _bindings.createCylinderCollider(_worldHandle, body.handle, halfHeight, radius);
    return Collider(body);
  }

  Collider createCapsuleCollider(RigidBody body, double halfHeight, double radius) {
    _bindings.createCapsuleCollider(_worldHandle, body.handle, halfHeight, radius);
    return Collider(body);
  }
}
