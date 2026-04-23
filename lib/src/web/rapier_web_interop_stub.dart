// Stub for web interop to allow compilation on non-web platforms.

dynamic rapier_init() => throw UnsupportedError('Web only');
dynamic rapier_version() => throw UnsupportedError('Web only');
dynamic rapier_world_create() => throw UnsupportedError('Web only');
void rapier_world_destroy(dynamic world) => throw UnsupportedError('Web only');
void rapier_world_set_gravity(dynamic world, dynamic x, dynamic y, dynamic z) => throw UnsupportedError('Web only');
void rapier_world_step(dynamic world) => throw UnsupportedError('Web only');
dynamic rapier_create_rigid_body(dynamic world, dynamic x, dynamic y, dynamic z, dynamic type) =>
    throw UnsupportedError('Web only');
void rapier_create_box_collider(dynamic world, dynamic body, dynamic hx, dynamic hy, dynamic hz) =>
    throw UnsupportedError('Web only');
void rapier_create_sphere_collider(dynamic world, dynamic body, dynamic radius) => throw UnsupportedError('Web only');
void rapier_create_cylinder_collider(dynamic world, dynamic body, dynamic halfHeight, dynamic radius) =>
    throw UnsupportedError('Web only');
void rapier_create_cone_collider(dynamic world, dynamic body, dynamic halfHeight, dynamic radius) =>
    throw UnsupportedError('Web only');
void rapier_create_capsule_collider(dynamic world, dynamic body, dynamic halfHeight, dynamic radius) =>
    throw UnsupportedError('Web only');

void rapier_create_heightfield_collider(
  dynamic world,
  dynamic body,
  dynamic heights,
  dynamic nrows,
  dynamic ncols,
  dynamic sx,
  dynamic sy,
  dynamic sz,
) => throw UnsupportedError('Web only');

dynamic rapier_malloc(dynamic size) => throw UnsupportedError('Web only');
void rapier_free(dynamic ptr, dynamic size) => throw UnsupportedError('Web only');

dynamic rapier_create_fixed_joint(
  dynamic world,
  dynamic body1,
  dynamic body2,
  dynamic a1x,
  dynamic a1y,
  dynamic a1z,
  dynamic r1x,
  dynamic r1y,
  dynamic r1z,
  dynamic r1w,
  dynamic a2x,
  dynamic a2y,
  dynamic a2z,
  dynamic r2x,
  dynamic r2y,
  dynamic r2z,
  dynamic r2w,
) => throw UnsupportedError('Web only');

dynamic rapier_create_spherical_joint(
  dynamic world,
  dynamic body1,
  dynamic body2,
  dynamic a1x,
  dynamic a1y,
  dynamic a1z,
  dynamic a2x,
  dynamic a2y,
  dynamic a2z,
) => throw UnsupportedError('Web only');

dynamic rapier_create_revolute_joint(
  dynamic world,
  dynamic body1,
  dynamic body2,
  dynamic vx,
  dynamic vy,
  dynamic vz,
  dynamic a1x,
  dynamic a1y,
  dynamic a1z,
  dynamic a2x,
  dynamic a2y,
  dynamic a2z,
) => throw UnsupportedError('Web only');

dynamic rapier_create_prismatic_joint(
  dynamic world,
  dynamic body1,
  dynamic body2,
  dynamic vx,
  dynamic vy,
  dynamic vz,
  dynamic a1x,
  dynamic a1y,
  dynamic a1z,
  dynamic a2x,
  dynamic a2y,
  dynamic a2z,
) => throw UnsupportedError('Web only');

dynamic rapier_create_generic_joint(
  dynamic world,
  dynamic body1,
  dynamic body2,
  dynamic a1x,
  dynamic a1y,
  dynamic a1z,
  dynamic a2x,
  dynamic a2y,
  dynamic a2z,
) => throw UnsupportedError('Web only');

dynamic rapier_create_rope_joint(
  dynamic world,
  dynamic body1,
  dynamic body2,
  dynamic a1x,
  dynamic a1y,
  dynamic a1z,
  dynamic a2x,
  dynamic a2y,
  dynamic a2z,
  dynamic maxDist,
) => throw UnsupportedError('Web only');

void rapier_joint_lock_axis(dynamic world, dynamic joint, dynamic axis, dynamic locked) =>
    throw UnsupportedError('Web only');

void rapier_joint_set_limits(dynamic world, dynamic joint, dynamic axis, dynamic min, dynamic max) =>
    throw UnsupportedError('Web only');

void rapier_joint_configure_motor(
  dynamic world,
  dynamic joint,
  dynamic axis,
  dynamic targetPos,
  dynamic targetVel,
  dynamic stiffness,
  dynamic damping,
) => throw UnsupportedError('Web only');

void rapier_joint_configure_revolute_motor(
  dynamic world,
  dynamic joint,
  dynamic targetPos,
  dynamic targetVel,
  dynamic stiffness,
  dynamic damping,
) => throw UnsupportedError('Web only');

void rapier_joint_configure_prismatic_motor(
  dynamic world,
  dynamic joint,
  dynamic targetPos,
  dynamic targetVel,
  dynamic stiffness,
  dynamic damping,
) => throw UnsupportedError('Web only');

dynamic rapier_get_body_position_x(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_position_y(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_position_z(dynamic world, dynamic body) => throw UnsupportedError('Web only');

dynamic rapier_get_body_rotation_x(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_rotation_y(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_rotation_z(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_rotation_w(dynamic world, dynamic body) => throw UnsupportedError('Web only');

void rapier_set_body_position(dynamic world, dynamic body, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_set_body_rotation(dynamic world, dynamic body, dynamic x, dynamic y, dynamic z, dynamic w) =>
    throw UnsupportedError('Web only');

void rapier_wake_body(dynamic world, dynamic body) => throw UnsupportedError('Web only');
void rapier_set_body_ccd(dynamic world, dynamic body, dynamic enabled) => throw UnsupportedError('Web only');

void rapier_set_collider_friction(dynamic world, dynamic handle, dynamic friction) =>
    throw UnsupportedError('Web only');
void rapier_set_collider_restitution(dynamic world, dynamic handle, dynamic restitution) =>
    throw UnsupportedError('Web only');
void rapier_set_collider_density(dynamic world, dynamic handle, dynamic density) => throw UnsupportedError('Web only');
void rapier_set_body_linear_damping(dynamic world, dynamic handle, dynamic damping) =>
    throw UnsupportedError('Web only');
void rapier_set_body_angular_damping(dynamic world, dynamic handle, dynamic damping) =>
    throw UnsupportedError('Web only');

void rapier_body_add_force(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_body_add_torque(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_body_apply_impulse(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_body_apply_torque_impulse(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_body_add_force_at_point(
        dynamic world, dynamic handle, dynamic fx, dynamic fy, dynamic fz, dynamic px, dynamic py, dynamic pz) =>
    throw UnsupportedError('Web only');
void rapier_body_apply_impulse_at_point(
        dynamic world, dynamic handle, dynamic ix, dynamic iy, dynamic iz, dynamic px, dynamic py, dynamic pz) =>
    throw UnsupportedError('Web only');

void rapier_body_set_linear_velocity(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_body_set_angular_velocity(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');

void rapier_world_remove_rigid_body(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
void rapier_world_remove_collider(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
void rapier_world_remove_joint(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
