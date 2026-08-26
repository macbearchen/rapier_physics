import 'dart:js_interop';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_desc.dart';
import '../collider_desc.dart';
import '../web/rapier_web_interop.dart' as web_ffi;
import 'rapier_bindings.dart';

class RapierBindingsImpl extends RapierBindings {
  // ==========================================
  // Initialization & Version
  // ==========================================

  static bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;
    await web_ffi.rapier_init().toDart;
    _initialized = true;
  }

  @override
  String getVersion() => web_ffi.rapier_version().toDart;

  // ==========================================
  // World
  // ==========================================

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
  double getTimestep(int world) => web_ffi.rapier_world_get_timestep(world.toJS).toDartDouble;

  @override
  void setTimestep(int world, double dt) => web_ffi.rapier_world_set_timestep(world.toJS, dt.toJS);

  // ==========================================
  // Rigid Body
  // ==========================================

  @override
  int createRigidBody(int world, RigidBodyDesc desc) {
    final handle = web_ffi
        .rapier_rigid_body_create(
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
  void removeRigidBody(int world, int handle) => web_ffi.rapier_rigid_body_remove(world.toJS, handle.toJS);

  @override
  Vector3 getBodyPosition(int world, int body) {
    final ptr = web_ffi.rapier_rigid_body_get_position(world.toJS, body.toJS);
    return Vector3(
      web_ffi.rapier_vec3_get_x(ptr).toDartDouble,
      web_ffi.rapier_vec3_get_y(ptr).toDartDouble,
      web_ffi.rapier_vec3_get_z(ptr).toDartDouble,
    );
  }

  @override
  Quaternion getBodyRotation(int world, int body) {
    final ptr = web_ffi.rapier_rigid_body_get_rotation(world.toJS, body.toJS);
    return Quaternion(
      web_ffi.rapier_quat_get_x(ptr).toDartDouble,
      web_ffi.rapier_quat_get_y(ptr).toDartDouble,
      web_ffi.rapier_quat_get_z(ptr).toDartDouble,
      web_ffi.rapier_quat_get_w(ptr).toDartDouble,
    );
  }

  @override
  void setBodyPosition(int world, int body, double x, double y, double z) =>
      web_ffi.rapier_rigid_body_set_position(world.toJS, body.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) =>
      web_ffi.rapier_rigid_body_set_rotation(world.toJS, body.toJS, x.toJS, y.toJS, z.toJS, w.toJS);

  @override
  void setBodyLinearDamping(int world, int handle, double damping) =>
      web_ffi.rapier_rigid_body_set_linear_damping(world.toJS, handle.toJS, damping.toJS);

  @override
  void setBodyAngularDamping(int world, int handle, double damping) =>
      web_ffi.rapier_rigid_body_set_angular_damping(world.toJS, handle.toJS, damping.toJS);

  @override
  void setBodyCCD(int world, int body, bool enabled) =>
      web_ffi.rapier_rigid_body_set_ccd(world.toJS, body.toJS, enabled.toJS);

  @override
  void wakeBody(int world, int body) => web_ffi.rapier_rigid_body_wake(world.toJS, body.toJS);

  @override
  void addForce(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_rigid_body_add_force(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void addTorque(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_rigid_body_add_torque(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void applyImpulse(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_rigid_body_apply_impulse(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void applyTorqueImpulse(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_rigid_body_apply_torque_impulse(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void addForceAtPoint(int world, int handle, double fx, double fy, double fz, double px, double py, double pz) =>
      web_ffi.rapier_rigid_body_add_force_at_point(
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
      web_ffi.rapier_rigid_body_apply_impulse_at_point(
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
      web_ffi.rapier_rigid_body_set_linear_velocity(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setBodyAngularVelocity(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_rigid_body_set_angular_velocity(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  // ==========================================
  // Collider
  // ==========================================

  @override
  int createCollider(int world, int body, ColliderDesc desc) {
    final handle = web_ffi
        .rapier_collider_create(
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
          desc.isSensor.toJS,
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
      .rapier_collider_create_heightfield(
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
  void removeCollider(int world, int handle) => web_ffi.rapier_collider_remove(world.toJS, handle.toJS);

  @override
  Vector3 getColliderPosition(int world, int handle) {
    final ptr = web_ffi.rapier_collider_get_position(world.toJS, handle.toJS);
    return Vector3(
      web_ffi.rapier_vec3_get_x(ptr).toDartDouble,
      web_ffi.rapier_vec3_get_y(ptr).toDartDouble,
      web_ffi.rapier_vec3_get_z(ptr).toDartDouble,
    );
  }

  @override
  Quaternion getColliderRotation(int world, int handle) {
    final ptr = web_ffi.rapier_collider_get_rotation(world.toJS, handle.toJS);
    return Quaternion(
      web_ffi.rapier_quat_get_x(ptr).toDartDouble,
      web_ffi.rapier_quat_get_y(ptr).toDartDouble,
      web_ffi.rapier_quat_get_z(ptr).toDartDouble,
      web_ffi.rapier_quat_get_w(ptr).toDartDouble,
    );
  }

  @override
  double getColliderFriction(int world, int handle) =>
      web_ffi.rapier_collider_get_friction(world.toJS, handle.toJS).toDartDouble;

  @override
  double getColliderRestitution(int world, int handle) =>
      web_ffi.rapier_collider_get_restitution(world.toJS, handle.toJS).toDartDouble;

  @override
  double getColliderDensity(int world, int handle) =>
      web_ffi.rapier_collider_get_density(world.toJS, handle.toJS).toDartDouble;

  @override
  void setColliderFriction(int world, int handle, double friction) =>
      web_ffi.rapier_collider_set_friction(world.toJS, handle.toJS, friction.toJS);

  @override
  void setColliderRestitution(int world, int handle, double restitution) =>
      web_ffi.rapier_collider_set_restitution(world.toJS, handle.toJS, restitution.toJS);

  @override
  void setColliderDensity(int world, int handle, double density) =>
      web_ffi.rapier_collider_set_density(world.toJS, handle.toJS, density.toJS);

  @override
  void setColliderPosition(int world, int handle, double x, double y, double z) =>
      web_ffi.rapier_collider_set_position(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setColliderRotation(int world, int handle, double x, double y, double z, double w) =>
      web_ffi.rapier_collider_set_rotation(world.toJS, handle.toJS, x.toJS, y.toJS, z.toJS, w.toJS);

  // ==========================================
  // Joint
  // ==========================================

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
      .rapier_joint_create_fixed(
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
      .rapier_joint_create_spherical(
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
      .rapier_joint_create_revolute(
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
      .rapier_joint_create_prismatic(
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
      .rapier_joint_create_generic(
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
      .rapier_joint_create_rope(
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
  void removeJoint(int world, int handle) => web_ffi.rapier_joint_remove(world.toJS, handle.toJS);

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

  // ==========================================
  // Kinematic Character Controller
  // ==========================================

  @override
  int createCharacterController(double offset) => web_ffi.rapier_character_controller_create(offset.toJS).toDartInt;

  @override
  void destroyCharacterController(int ctrl) => web_ffi.rapier_character_controller_destroy(ctrl.toJS);

  @override
  void setCharacterControllerUp(int ctrl, double x, double y, double z) =>
      web_ffi.rapier_character_controller_set_up(ctrl.toJS, x.toJS, y.toJS, z.toJS);

  @override
  void setCharacterControllerMaxSlope(int ctrl, double angleRadians) =>
      web_ffi.rapier_character_controller_set_max_slope(ctrl.toJS, angleRadians.toJS);

  @override
  void setCharacterControllerMinSlope(int ctrl, double angleRadians) =>
      web_ffi.rapier_character_controller_set_min_slope(ctrl.toJS, angleRadians.toJS);

  @override
  void setCharacterControllerSnapToGround(int ctrl, double distance, bool enabled) =>
      web_ffi.rapier_character_controller_set_snap_to_ground(ctrl.toJS, distance.toJS, enabled.toJS);

  @override
  void setCharacterControllerAutoStep(int ctrl, double maxHeight, double minWidth, bool includeDynamicBodies) => web_ffi
      .rapier_character_controller_set_autostep(ctrl.toJS, maxHeight.toJS, minWidth.toJS, includeDynamicBodies.toJS);

  @override
  Vector3 moveCharacter(int world, int ctrl, int colliderHandle, double dx, double dy, double dz, double dt) {
    final result = web_ffi.rapier_character_controller_move(
      world.toJS,
      ctrl.toJS,
      colliderHandle.toJS,
      dx.toJS,
      dy.toJS,
      dz.toJS,
      dt.toJS,
    );
    return Vector3(
      web_ffi.rapier_vec3_get_x(result).toDartDouble,
      web_ffi.rapier_vec3_get_y(result).toDartDouble,
      web_ffi.rapier_vec3_get_z(result).toDartDouble,
    );
  }

  @override
  bool isCharacterGrounded(int ctrl) => web_ffi.rapier_character_controller_is_grounded(ctrl.toJS).toDart;

  @override
  bool isCharacterOnWall(int ctrl) => web_ffi.rapier_character_controller_is_on_wall(ctrl.toJS).toDart;

  @override
  bool isCharacterOnCeiling(int ctrl) => web_ffi.rapier_character_controller_is_on_ceiling(ctrl.toJS).toDart;

  // ==========================================
  // Scene Queries (QueryPipeline)
  // ==========================================

  @override
  RayHitData? castRay(
    int world,
    double ox,
    double oy,
    double oz,
    double dx,
    double dy,
    double dz,
    double maxToi,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final ptr = web_ffi.rapier_world_cast_ray(
      world.toJS,
      ox.toJS,
      oy.toJS,
      oz.toJS,
      dx.toJS,
      dy.toJS,
      dz.toJS,
      maxToi.toJS,
      solid.toJS,
      excludeCollider.toJS,
      excludeRigidBody.toJS,
    );
    if (!web_ffi.rapier_ray_get_hit(ptr).toDart) return null;
    return RayHitData(
      colliderHandle: web_ffi.rapier_ray_get_collider(ptr).toDartInt,
      rigidBodyHandle: web_ffi.rapier_ray_get_rigid_body(ptr).toDartInt,
      toi: web_ffi.rapier_ray_get_toi(ptr).toDartDouble,
      point: Vector3(
        web_ffi.rapier_ray_get_point_x(ptr).toDartDouble,
        web_ffi.rapier_ray_get_point_y(ptr).toDartDouble,
        web_ffi.rapier_ray_get_point_z(ptr).toDartDouble,
      ),
      normal: Vector3(
        web_ffi.rapier_ray_get_normal_x(ptr).toDartDouble,
        web_ffi.rapier_ray_get_normal_y(ptr).toDartDouble,
        web_ffi.rapier_ray_get_normal_z(ptr).toDartDouble,
      ),
    );
  }

  @override
  RayHitData? castRayAndGetNormal(
    int world,
    double ox,
    double oy,
    double oz,
    double dx,
    double dy,
    double dz,
    double maxToi,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final ptr = web_ffi.rapier_world_cast_ray_and_get_normal(
      world.toJS,
      ox.toJS,
      oy.toJS,
      oz.toJS,
      dx.toJS,
      dy.toJS,
      dz.toJS,
      maxToi.toJS,
      solid.toJS,
      excludeCollider.toJS,
      excludeRigidBody.toJS,
    );
    if (!web_ffi.rapier_ray_get_hit(ptr).toDart) return null;
    return RayHitData(
      colliderHandle: web_ffi.rapier_ray_get_collider(ptr).toDartInt,
      rigidBodyHandle: web_ffi.rapier_ray_get_rigid_body(ptr).toDartInt,
      toi: web_ffi.rapier_ray_get_toi(ptr).toDartDouble,
      point: Vector3(
        web_ffi.rapier_ray_get_point_x(ptr).toDartDouble,
        web_ffi.rapier_ray_get_point_y(ptr).toDartDouble,
        web_ffi.rapier_ray_get_point_z(ptr).toDartDouble,
      ),
      normal: Vector3(
        web_ffi.rapier_ray_get_normal_x(ptr).toDartDouble,
        web_ffi.rapier_ray_get_normal_y(ptr).toDartDouble,
        web_ffi.rapier_ray_get_normal_z(ptr).toDartDouble,
      ),
    );
  }

  @override
  ShapeHitData? castShape(
    int world,
    double px,
    double py,
    double pz,
    double rx,
    double ry,
    double rz,
    double rw,
    double vx,
    double vy,
    double vz,
    ColliderDesc desc,
    double maxToi,
    bool stopAtPenetration,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final ptr = web_ffi.rapier_world_cast_shape(
      world.toJS,
      px.toJS,
      py.toJS,
      pz.toJS,
      rx.toJS,
      ry.toJS,
      rz.toJS,
      rw.toJS,
      vx.toJS,
      vy.toJS,
      vz.toJS,
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
      desc.isSensor.toJS,
      maxToi.toJS,
      stopAtPenetration.toJS,
      excludeCollider.toJS,
      excludeRigidBody.toJS,
    );
    if (!web_ffi.rapier_ray_get_hit(ptr).toDart) return null;
    return ShapeHitData(
      colliderHandle: web_ffi.rapier_ray_get_collider(ptr).toDartInt,
      rigidBodyHandle: web_ffi.rapier_ray_get_rigid_body(ptr).toDartInt,
      toi: web_ffi.rapier_ray_get_toi(ptr).toDartDouble,
      point: Vector3(
        web_ffi.rapier_ray_get_point_x(ptr).toDartDouble,
        web_ffi.rapier_ray_get_point_y(ptr).toDartDouble,
        web_ffi.rapier_ray_get_point_z(ptr).toDartDouble,
      ),
      normal: Vector3(
        web_ffi.rapier_ray_get_normal_x(ptr).toDartDouble,
        web_ffi.rapier_ray_get_normal_y(ptr).toDartDouble,
        web_ffi.rapier_ray_get_normal_z(ptr).toDartDouble,
      ),
    );
  }

  @override
  PointProjectionData? projectPoint(
    int world,
    double px,
    double py,
    double pz,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final ptr = web_ffi.rapier_world_project_point(
      world.toJS,
      px.toJS,
      py.toJS,
      pz.toJS,
      solid.toJS,
      excludeCollider.toJS,
      excludeRigidBody.toJS,
    );
    if (!web_ffi.rapier_proj_get_hit(ptr).toDart) return null;
    return PointProjectionData(
      colliderHandle: web_ffi.rapier_proj_get_collider(ptr).toDartInt,
      rigidBodyHandle: web_ffi.rapier_proj_get_rigid_body(ptr).toDartInt,
      point: Vector3(
        web_ffi.rapier_proj_get_point_x(ptr).toDartDouble,
        web_ffi.rapier_proj_get_point_y(ptr).toDartDouble,
        web_ffi.rapier_proj_get_point_z(ptr).toDartDouble,
      ),
      isInside: web_ffi.rapier_proj_get_is_inside(ptr).toDart,
    );
  }

  @override
  List<int> intersectionsWithPoint(
    int world,
    double px,
    double py,
    double pz,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final jsArr = web_ffi.rapier_world_intersections_with_point(
      world.toJS,
      px.toJS,
      py.toJS,
      pz.toJS,
      excludeCollider.toJS,
      excludeRigidBody.toJS,
    );
    final result = <int>[];
    for (var i = 0; i < jsArr.length; i++) {
      final item = jsArr.toDart[i] as JSNumber;
      result.add(item.toDartInt);
    }
    return result;
  }

  @override
  int intersectionWithShape(
    int world,
    double px,
    double py,
    double pz,
    double rx,
    double ry,
    double rz,
    double rw,
    ColliderDesc desc,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    return web_ffi
        .rapier_world_intersection_with_shape(
          world.toJS,
          px.toJS,
          py.toJS,
          pz.toJS,
          rx.toJS,
          ry.toJS,
          rz.toJS,
          rw.toJS,
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
          desc.isSensor.toJS,
          excludeCollider.toJS,
          excludeRigidBody.toJS,
        )
        .toDartInt;
  }
}

