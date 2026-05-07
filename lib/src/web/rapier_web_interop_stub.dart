// Stub for web interop to allow compilation on non-web platforms.

// ignore_for_file: non_constant_identifier_names

dynamic rapier_init() => throw UnsupportedError('Web only');
dynamic rapier_version() => throw UnsupportedError('Web only');
dynamic rapier_world_create() => throw UnsupportedError('Web only');
void rapier_world_destroy(dynamic world) => throw UnsupportedError('Web only');
void rapier_world_set_gravity(dynamic world, dynamic x, dynamic y, dynamic z) => throw UnsupportedError('Web only');
void rapier_world_step(dynamic world) => throw UnsupportedError('Web only');
dynamic rapier_rigid_body_create(dynamic world, dynamic x, dynamic y, dynamic z, dynamic type) =>
    throw UnsupportedError('Web only');
void rapier_collider_create(
  dynamic world,
  dynamic body,
  dynamic shapeType,
  dynamic hx,
  dynamic hy,
  dynamic hz,
  dynamic radius,
  dynamic halfHeight,
  dynamic friction,
  dynamic restitution,
  dynamic density,
  dynamic localPositionX,
  dynamic localPositionY,
  dynamic localPositionZ,
  dynamic localRotationX,
  dynamic localRotationY,
  dynamic localRotationZ,
  dynamic localRotationW,
  dynamic isSensor,
) => throw UnsupportedError('Web only');

void rapier_collider_create_heightfield(
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

dynamic rapier_joint_create_fixed(
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

dynamic rapier_joint_create_spherical(
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

dynamic rapier_joint_create_revolute(
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

dynamic rapier_joint_create_prismatic(
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

dynamic rapier_joint_create_generic(
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

dynamic rapier_joint_create_rope(
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

dynamic rapier_rigid_body_get_position_x(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_rigid_body_get_position_y(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_rigid_body_get_position_z(dynamic world, dynamic body) => throw UnsupportedError('Web only');

dynamic rapier_rigid_body_get_rotation_x(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_rigid_body_get_rotation_y(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_rigid_body_get_rotation_z(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_rigid_body_get_rotation_w(dynamic world, dynamic body) => throw UnsupportedError('Web only');

dynamic rapier_collider_get_position_x(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_position_y(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_position_z(dynamic world, dynamic handle) => throw UnsupportedError('Web only');

dynamic rapier_collider_get_rotation_x(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_rotation_y(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_rotation_z(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_rotation_w(dynamic world, dynamic handle) => throw UnsupportedError('Web only');

dynamic rapier_collider_get_friction(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_restitution(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
dynamic rapier_collider_get_density(dynamic world, dynamic handle) => throw UnsupportedError('Web only');

void rapier_rigid_body_set_position(dynamic world, dynamic body, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_set_rotation(dynamic world, dynamic body, dynamic x, dynamic y, dynamic z, dynamic w) =>
    throw UnsupportedError('Web only');

void rapier_rigid_body_wake(dynamic world, dynamic body) => throw UnsupportedError('Web only');
void rapier_rigid_body_set_ccd(dynamic world, dynamic body, dynamic enabled) => throw UnsupportedError('Web only');

void rapier_collider_set_friction(dynamic world, dynamic handle, dynamic friction) =>
    throw UnsupportedError('Web only');
void rapier_collider_set_restitution(dynamic world, dynamic handle, dynamic restitution) =>
    throw UnsupportedError('Web only');
void rapier_collider_set_density(dynamic world, dynamic handle, dynamic density) => throw UnsupportedError('Web only');
void rapier_collider_set_position(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_collider_set_rotation(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z, dynamic w) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_set_linear_damping(dynamic world, dynamic handle, dynamic damping) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_set_angular_damping(dynamic world, dynamic handle, dynamic damping) =>
    throw UnsupportedError('Web only');

void rapier_rigid_body_add_force(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_add_torque(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_apply_impulse(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_apply_torque_impulse(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_add_force_at_point(
  dynamic world,
  dynamic handle,
  dynamic fx,
  dynamic fy,
  dynamic fz,
  dynamic px,
  dynamic py,
  dynamic pz,
) => throw UnsupportedError('Web only');
void rapier_rigid_body_apply_impulse_at_point(
  dynamic world,
  dynamic handle,
  dynamic ix,
  dynamic iy,
  dynamic iz,
  dynamic px,
  dynamic py,
  dynamic pz,
) => throw UnsupportedError('Web only');

void rapier_rigid_body_set_linear_velocity(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');
void rapier_rigid_body_set_angular_velocity(dynamic world, dynamic handle, dynamic x, dynamic y, dynamic z) =>
    throw UnsupportedError('Web only');

void rapier_rigid_body_remove(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
void rapier_collider_remove(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
void rapier_joint_remove(dynamic world, dynamic handle) => throw UnsupportedError('Web only');
