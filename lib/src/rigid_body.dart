import 'rapier_world.dart';

class RigidBody {
  final int handle;
  final RapierWorld world;

  RigidBody(this.handle, this.world);

  Vector3 get position => world.getBodyPosition(handle);
  void setPosition(double x, double y, double z) => world.setBodyPosition(handle, x, y, z);

  Quaternion get rotation => world.getBodyRotation(handle);
  void setRotation(double x, double y, double z, double w) => world.setBodyRotation(handle, x, y, z, w);
}
