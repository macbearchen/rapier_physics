import 'dart:js_interop';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_type.dart';
import '../web/rapier_web_interop.dart' as web_ffi;
import 'rapier_bindings.dart';

class RapierBindingsImpl extends RapierBindings {
  @override
  Future<void> init() async {
    await web_ffi.rapier_init().toDart;
  }

  @override
  String getVersion() => web_ffi.rapier_version().toDart;

  @override
  int createWorld() => web_ffi.rapier_world_create().toDartInt;

  @override
  void setGravity(int world, double x, double y, double z) =>
      web_ffi.rapier_world_set_gravity(world.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void stepWorld(int world) => web_ffi.rapier_world_step(world.toJS);

  @override
  int createRigidBody(int world, double x, double y, double z, RigidBodyType type) =>
      web_ffi.rapier_create_rigid_body(world.toJS, x.toJS, y.toJS, z.toJS, type.index.toJS).toDartInt;

  @override
  void createBoxCollider(int world, int body, double hx, double hy, double hz) =>
      web_ffi.rapier_create_box_collider(world.toJS, body.toJS, hx.toJS, hy.toJS, hz.toJS);

  @override
  void createSphereCollider(int world, int body, double radius) =>
      web_ffi.rapier_create_sphere_collider(world.toJS, body.toJS, radius.toJS);

  @override
  void createCylinderCollider(int world, int body, double halfHeight, double radius) =>
      web_ffi.rapier_create_cylinder_collider(world.toJS, body.toJS, halfHeight.toJS, radius.toJS);

  @override
  void createCapsuleCollider(int world, int body, double halfHeight, double radius) =>
      web_ffi.rapier_create_capsule_collider(world.toJS, body.toJS, halfHeight.toJS, radius.toJS);

  @override
  Vector3 getBodyPosition(int world, int body) {
    return Vector3(
      web_ffi.rapier_get_body_position_x(world.toJS, body.toJS).toDartDouble,
      web_ffi.rapier_get_body_position_y(world.toJS, body.toJS).toDartDouble,
      web_ffi.rapier_get_body_position_z(world.toJS, body.toJS).toDartDouble,
    );
  }

  @override
  Quaternion getBodyRotation(int world, int body) {
    return Quaternion(
      web_ffi.rapier_get_body_rotation_x(world.toJS, body.toJS).toDartDouble,
      web_ffi.rapier_get_body_rotation_y(world.toJS, body.toJS).toDartDouble,
      web_ffi.rapier_get_body_rotation_z(world.toJS, body.toJS).toDartDouble,
      web_ffi.rapier_get_body_rotation_w(world.toJS, body.toJS).toDartDouble,
    );
  }

  @override
  void setBodyPosition(int world, int body, double x, double y, double z) =>
      web_ffi.rapier_set_body_position(world.toJS, body.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) =>
      web_ffi.rapier_set_body_rotation(world.toJS, body.toJS, x.toJS, y.toJS, z.toJS, w.toJS);
}
