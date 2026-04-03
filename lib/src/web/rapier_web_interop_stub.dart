// Stub for web interop to allow compilation on non-web platforms.

dynamic rapier_init() => throw UnsupportedError('Web only');
dynamic rapier_version() => throw UnsupportedError('Web only');
dynamic rapier_world_create() => throw UnsupportedError('Web only');
void rapier_world_step(dynamic world) => throw UnsupportedError('Web only');
dynamic rapier_create_rigid_body(
  dynamic world,
  dynamic x,
  dynamic y,
  dynamic z,
  dynamic type,
) =>
    throw UnsupportedError('Web only');
void rapier_create_box_collider(
  dynamic world,
  dynamic body,
  dynamic hx,
  dynamic hy,
  dynamic hz,
) =>
    throw UnsupportedError('Web only');
void rapier_create_sphere_collider(
  dynamic world,
  dynamic body,
  dynamic radius,
) =>
    throw UnsupportedError('Web only');
void rapier_create_cylinder_collider(
  dynamic world,
  dynamic body,
  dynamic halfHeight,
  dynamic radius,
) =>
    throw UnsupportedError('Web only');
void rapier_create_capsule_collider(
  dynamic world,
  dynamic body,
  dynamic halfHeight,
  dynamic radius,
) =>
    throw UnsupportedError('Web only');

dynamic rapier_get_body_position_x(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_position_y(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_position_z(dynamic world, dynamic body) => throw UnsupportedError('Web only');

dynamic rapier_get_body_rotation_x(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_rotation_y(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_rotation_z(dynamic world, dynamic body) => throw UnsupportedError('Web only');
dynamic rapier_get_body_rotation_w(dynamic world, dynamic body) => throw UnsupportedError('Web only');

void rapier_set_body_position(
  dynamic world,
  dynamic body,
  dynamic x,
  dynamic y,
  dynamic z,
) =>
    throw UnsupportedError('Web only');
void rapier_set_body_rotation(
  dynamic world,
  dynamic body,
  dynamic x,
  dynamic y,
  dynamic z,
  dynamic w,
) =>
    throw UnsupportedError('Web only');
