import 'dart:js_interop';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_desc.dart';
import '../collider_desc.dart';
import '../web/rapier_web_interop.dart' as web_ffi;
import 'rapier_bindings.dart';

class RapierBindingsImpl extends RapierBindings {
  @override
  Future<void> init() async {
    await web_ffi.rapier_init().toDart;
  }

  @override
  String getVersion() => web_ffi.rapier_version().toDart;

  // --- World ---
  @override
  int createWorld() => web_ffi.rapier_world_create().toDartInt;

  @override
  void setGravity(int world, double x, double y, double z) =>
      web_ffi.rapier_world_set_gravity(world.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void destroyWorld(int world) => web_ffi.rapier_world_destroy(world.toJS);

  @override
  void stepWorld(int world) => web_ffi.rapier_world_step(world.toJS);

  // --- RigidBody ---
  @override
  int createRigidBody(int world, RigidBodyDesc desc) {
    final handle = web_ffi
        .rapier_create_rigid_body(
          world.toJS,
          desc.position.x.toJS,
          desc.position.y.toJS,
          desc.position.z.toJS,
          desc.type.index.toJS,
        )
        .toDartInt;

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

  @override
  void removeRigidBody(int world, int handle) => web_ffi.rapier_world_remove_rigid_body(world.toJS, handle.toJS);

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
  void setBodyLinearDamping(int world, int handle, double damping) =>
      web_ffi.rapier_set_body_linear_damping(world.toJS, handle.toJS, damping.toJS);

  @override
  void setBodyAngularDamping(int world, int handle, double damping) =>
      web_ffi.rapier_set_body_angular_damping(world.toJS, handle.toJS, damping.toJS);

  @override
  void setBodyCCD(int world, int body, bool enabled) =>
      web_ffi.rapier_set_body_ccd(world.toJS, body.toJS, enabled.toJS);

  @override
  void wakeBody(int world, int body) => web_ffi.rapier_wake_body(world.toJS, body.toJS);

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
        world.toJS,
        handle.toJS,
        fx.toJS,
        fy.toJS,
        fz.toJS,
        px.toJS,
        py.toJS,
        pz.toJS,
      );

  @override
  void applyImpulseAtPoint(int world, int handle, double ix, double iy, double iz, double px, double py, double pz) =>
      web_ffi.rapier_body_apply_impulse_at_point(
        world.toJS,
        handle.toJS,
        ix.toJS,
        iy.toJS,
        iz.toJS,
        px.toJS,
        py.toJS,
        pz.toJS,
      );

  @override
  void setBodyLinearVelocity(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_set_linear_velocity(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setBodyAngularVelocity(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_body_set_angular_velocity(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  // --- Collider ---
  @override
  int createCollider(int world, int body, ColliderDesc desc) {
    final handle = web_ffi
        .rapier_create_collider(
          world.toJS,
          body.toJS,
          desc.shapeType.index.toJS,
          desc.hx.toJS,
          desc.hy.toJS,
          desc.hz.toJS,
          desc.radius.toJS,
          desc.halfHeight.toJS,
          desc.friction.toJS,
          desc.restitution.toJS,
          desc.density.toJS,
          desc.localPosition.x.toJS,
          desc.localPosition.y.toJS,
          desc.localPosition.z.toJS,
          desc.localRotation.x.toJS,
          desc.localRotation.y.toJS,
          desc.localRotation.z.toJS,
          desc.localRotation.w.toJS,
        )
        .toDartInt;

    return handle;
  }

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
  void removeCollider(int world, int handle) => web_ffi.rapier_world_remove_collider(world.toJS, handle.toJS);

  @override
  Vector3 getColliderPosition(int world, int handle) => Vector3(
    web_ffi.rapier_get_collider_position_x(world.toJS, handle.toJS).toDartDouble,
    web_ffi.rapier_get_collider_position_y(world.toJS, handle.toJS).toDartDouble,
    web_ffi.rapier_get_collider_position_z(world.toJS, handle.toJS).toDartDouble,
  );

  @override
  Quaternion getColliderRotation(int world, int handle) => Quaternion(
    web_ffi.rapier_get_collider_rotation_x(world.toJS, handle.toJS).toDartDouble,
    web_ffi.rapier_get_collider_rotation_y(world.toJS, handle.toJS).toDartDouble,
    web_ffi.rapier_get_collider_rotation_z(world.toJS, handle.toJS).toDartDouble,
    web_ffi.rapier_get_collider_rotation_w(world.toJS, handle.toJS).toDartDouble,
  );

  @override
  double getColliderFriction(int world, int handle) =>
      web_ffi.rapier_get_collider_friction(world.toJS, handle.toJS).toDartDouble;

  @override
  double getColliderRestitution(int world, int handle) =>
      web_ffi.rapier_get_collider_restitution(world.toJS, handle.toJS).toDartDouble;

  @override
  double getColliderDensity(int world, int handle) =>
      web_ffi.rapier_get_collider_density(world.toJS, handle.toJS).toDartDouble;

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
  void setColliderPosition(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_set_collider_position(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setColliderRotation(int world, int handle, double x, double y, double z, double w) =>
      web_ffi.rapier_set_collider_rotation(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS, w.toJS);

  // --- Joint ---
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
  void removeJoint(int world, int handle) => web_ffi.rapier_world_remove_joint(world.toJS, handle.toJS);

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
}
