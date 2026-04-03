import 'package:vector_math/vector_math.dart';
import '../rigid_body_type.dart';
import 'rapier_bindings.dart';

class RapierBindingsImpl extends RapierBindings {
  @override
  String getVersion() => throw UnsupportedError('Stub');
  @override
  int createWorld() => throw UnsupportedError('Stub');
  @override
  void setGravity(int world, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void stepWorld(int world) => throw UnsupportedError('Stub');
  @override
  int createRigidBody(int world, double x, double y, double z, RigidBodyType type) => throw UnsupportedError('Stub');
  @override
  void createBoxCollider(int world, int body, double hx, double hy, double hz) => throw UnsupportedError('Stub');
  @override
  void createSphereCollider(int world, int body, double radius) => throw UnsupportedError('Stub');
  @override
  void createCylinderCollider(int world, int body, double halfHeight, double radius) => throw UnsupportedError('Stub');
  @override
  void createCapsuleCollider(int world, int body, double halfHeight, double radius) => throw UnsupportedError('Stub');
  @override
  Vector3 getBodyPosition(int world, int body) => throw UnsupportedError('Stub');
  @override
  Quaternion getBodyRotation(int world, int body) => throw UnsupportedError('Stub');
  @override
  void setBodyPosition(int world, int body, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) => throw UnsupportedError('Stub');
  @override
  Future<void> init() async {}
}
