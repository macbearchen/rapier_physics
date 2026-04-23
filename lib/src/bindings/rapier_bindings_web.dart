import 'dart:js_interop';
import 'dart:typed_data';
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
  void destroyWorld(int world) => web_ffi.rapier_world_destroy(world.toJS);

  @override
  void stepWorld(int world) => web_ffi.rapier_world_step(world.toJS);

  @override
  int createRigidBody(int world, double x, double y, double z, RigidBodyType type) =>
      web_ffi.rapier_create_rigid_body(world.toJS, x.toJS, y.toJS, z.toJS, type.index.toJS).toDartInt;

  @override
  int createBoxCollider(int world, int body, double hx, double hy, double hz) =>
      web_ffi.rapier_create_box_collider(world.toJS, body.toJS, hx.toJS, hy.toJS, hz.toJS).toDartInt;

  @override
  int createSphereCollider(int world, int body, double radius) =>
      web_ffi.rapier_create_sphere_collider(world.toJS, body.toJS, radius.toJS).toDartInt;

  @override
  int createCylinderCollider(int world, int body, double halfHeight, double radius) =>
      web_ffi.rapier_create_cylinder_collider(world.toJS, body.toJS, halfHeight.toJS, radius.toJS).toDartInt;

  @override
  int createConeCollider(int world, int body, double halfHeight, double radius) =>
      web_ffi.rapier_create_cone_collider(world.toJS, body.toJS, halfHeight.toJS, radius.toJS).toDartInt;

  @override
  int createCapsuleCollider(int world, int body, double halfHeight, double radius) =>
      web_ffi.rapier_create_capsule_collider(world.toJS, body.toJS, halfHeight.toJS, radius.toJS).toDartInt;

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
  ) => web_ffi
      .rapier_create_heightfield_collider(
        world.toJS,
        body.toJS,
        heights.toJS,
        nrows.toJS,
        ncols.toJS,
        sx.toJS,
        sy.toJS,
        sz.toJS,
      )
      .toDartInt;

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
  ) => web_ffi
      .rapier_create_fixed_joint(
        world.toJS,
        body1.toJS,
        body2.toJS,
        a1x.toJS,
        a1y.toJS,
        a1z.toJS,
        r1x.toJS,
        r1y.toJS,
        r1z.toJS,
        r1w.toJS,
        a2x.toJS,
        a2y.toJS,
        a2z.toJS,
        r2x.toJS,
        r2y.toJS,
        r2z.toJS,
        r2w.toJS,
      )
      .toDartInt;

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
  ) => web_ffi
      .rapier_create_spherical_joint(
        world.toJS,
        body1.toJS,
        body2.toJS,
        a1x.toJS,
        a1y.toJS,
        a1z.toJS,
        a2x.toJS,
        a2y.toJS,
        a2z.toJS,
      )
      .toDartInt;

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
  ) => web_ffi
      .rapier_create_revolute_joint(
        world.toJS,
        body1.toJS,
        body2.toJS,
        vx.toJS,
        vy.toJS,
        vz.toJS,
        a1x.toJS,
        a1y.toJS,
        a1z.toJS,
        a2x.toJS,
        a2y.toJS,
        a2z.toJS,
      )
      .toDartInt;

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
  ) => web_ffi
      .rapier_create_prismatic_joint(
        world.toJS,
        body1.toJS,
        body2.toJS,
        vx.toJS,
        vy.toJS,
        vz.toJS,
        a1x.toJS,
        a1y.toJS,
        a1z.toJS,
        a2x.toJS,
        a2y.toJS,
        a2z.toJS,
      )
      .toDartInt;

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
  ) => web_ffi
      .rapier_create_generic_joint(
        world.toJS,
        body1.toJS,
        body2.toJS,
        a1x.toJS,
        a1y.toJS,
        a1z.toJS,
        a2x.toJS,
        a2y.toJS,
        a2z.toJS,
      )
      .toDartInt;

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
  ) => web_ffi
      .rapier_create_rope_joint(
        world.toJS,
        body1.toJS,
        body2.toJS,
        a1x.toJS,
        a1y.toJS,
        a1z.toJS,
        a2x.toJS,
        a2y.toJS,
        a2z.toJS,
        maxDist.toJS,
      )
      .toDartInt;

  @override
  void lockJointAxis(int world, int joint, int axis, bool locked) =>
      web_ffi.rapier_joint_lock_axis(world.toJS, joint.toJS, axis.toJS, locked.toJS);

  @override
  void setJointLimits(int world, int joint, int axis, double min, double max) =>
      web_ffi.rapier_joint_set_limits(world.toJS, joint.toJS, axis.toJS, min.toJS, max.toJS);

  @override
  void configureJointMotor(
    int world,
    int joint,
    int axis,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => web_ffi.rapier_joint_configure_motor(
    world.toJS,
    joint.toJS,
    axis.toJS,
    targetPos.toJS,
    targetVel.toJS,
    stiffness.toJS,
    damping.toJS,
  );

  @override
  void configureRevoluteJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => web_ffi.rapier_joint_configure_revolute_motor(
    world.toJS,
    joint.toJS,
    targetPos.toJS,
    targetVel.toJS,
    stiffness.toJS,
    damping.toJS,
  );

  @override
  void configurePrismaticJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => web_ffi.rapier_joint_configure_prismatic_motor(
    world.toJS,
    joint.toJS,
    targetPos.toJS,
    targetVel.toJS,
    stiffness.toJS,
    damping.toJS,
  );

  @override
  Vector3 getBodyPosition(int world, int body) => Vector3(
    web_ffi.rapier_get_body_position_x(world.toJS, body.toJS).toDartDouble,
    web_ffi.rapier_get_body_position_y(world.toJS, body.toJS).toDartDouble,
    web_ffi.rapier_get_body_position_z(world.toJS, body.toJS).toDartDouble,
  );

  @override
  Quaternion getBodyRotation(int world, int body) => Quaternion(
    web_ffi.rapier_get_body_rotation_x(world.toJS, body.toJS).toDartDouble,
    web_ffi.rapier_get_body_rotation_y(world.toJS, body.toJS).toDartDouble,
    web_ffi.rapier_get_body_rotation_z(world.toJS, body.toJS).toDartDouble,
    web_ffi.rapier_get_body_rotation_w(world.toJS, body.toJS).toDartDouble,
  );

  @override
  void setBodyPosition(int world, int body, double x, double y, double z) =>
      web_ffi.rapier_set_body_position(world.toJS, body.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) =>
      web_ffi.rapier_set_body_rotation(world.toJS, body.toJS, x.toJS, y.toJS, z.toJS, w.toJS);

  @override
  void setBodyCCD(int world, int body, bool enabled) =>
      web_ffi.rapier_set_body_ccd(world.toJS, body.toJS, enabled.toJS);

  @override
  void wakeBody(int world, int body) => web_ffi.rapier_wake_body(world.toJS, body.toJS);

  @override
  void setColliderFriction(int world, int handle, double friction) =>
      web_ffi.rapier_set_collider_friction(world.toJS, handle.toJS, friction.toJS);

  @override
  void setColliderRestitution(int world, int handle, double restitution) =>
      web_ffi.rapier_set_collider_restitution(world.toJS, handle.toJS, restitution.toJS);

  @override
  void setColliderDensity(int world, int handle, double density) =>
      web_ffi.rapier_set_collider_density(world.toJS, handle.toJS, density.toJS);

  @override
  void setBodyLinearDamping(int world, int handle, double damping) =>
      web_ffi.rapier_set_body_linear_damping(world.toJS, handle.toJS, damping.toJS);

  @override
  void setBodyAngularDamping(int world, int handle, double damping) =>
      web_ffi.rapier_set_body_angular_damping(world.toJS, handle.toJS, damping.toJS);

  @override
  void addForce(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_add_force(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void addTorque(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_add_torque(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void applyImpulse(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_apply_impulse(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void applyTorqueImpulse(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_apply_torque_impulse(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void addForceAtPoint(int world, int handle, double fx, double fy, double fz, double px, double py, double pz) =>
      web_ffi.rapier_body_add_force_at_point(
          world.toJS, handle.toJS, fx.toJS, fy.toJS, fz.toJS, px.toJS, py.toJS, pz.toJS);

  @override
  void applyImpulseAtPoint(int world, int handle, double ix, double iy, double iz, double px, double py, double pz) =>
      web_ffi.rapier_body_apply_impulse_at_point(
          world.toJS, handle.toJS, ix.toJS, iy.toJS, iz.toJS, px.toJS, py.toJS, pz.toJS);

  @override
  void setBodyLinearVelocity(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_set_linear_velocity(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setBodyAngularVelocity(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_set_angular_velocity(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void removeRigidBody(int world, int handle) => web_ffi.rapier_world_remove_rigid_body(world.toJS, handle.toJS);

  @override
  void removeCollider(int world, int handle) => web_ffi.rapier_world_remove_collider(world.toJS, handle.toJS);

  @override
  void removeJoint(int world, int handle) => web_ffi.rapier_world_remove_joint(world.toJS, handle.toJS);
}
