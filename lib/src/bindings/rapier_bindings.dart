import 'package:vector_math/vector_math.dart';
import '../rigid_body_type.dart';

abstract class RapierBindings {
  String getVersion();
  int createWorld();
  void setGravity(int world, double x, double y, double z);
  void stepWorld(int world);

  int createRigidBody(int world, double x, double y, double z, RigidBodyType type);

  void createBoxCollider(int world, int body, double hx, double hy, double hz);
  void createSphereCollider(int world, int body, double radius);
  void createCylinderCollider(int world, int body, double halfHeight, double radius);
  void createCapsuleCollider(int world, int body, double halfHeight, double radius);

  Vector3 getBodyPosition(int world, int body);
  Quaternion getBodyRotation(int world, int body);

  void setBodyPosition(int world, int body, double x, double y, double z);
  void setBodyRotation(int world, int body, double x, double y, double z, double w);

  Future<void> init();
}
