import 'dart:js_interop';

@JS()
external JSPromise rapier_init();

@JS()
external JSString rapier_version();

@JS()
external JSNumber rapier_world_create();

@JS()
external void rapier_world_set_gravity(JSNumber world, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_world_step(JSNumber world);

@JS()
external JSNumber rapier_create_rigid_body(
  JSNumber world,
  JSNumber x,
  JSNumber y,
  JSNumber z,
  JSNumber type,
);

@JS()
external void rapier_create_box_collider(
  JSNumber world,
  JSNumber body,
  JSNumber hx,
  JSNumber hy,
  JSNumber hz,
);

@JS()
external void rapier_create_sphere_collider(
  JSNumber world,
  JSNumber body,
  JSNumber radius,
);

@JS()
external void rapier_create_cylinder_collider(
  JSNumber world,
  JSNumber body,
  JSNumber halfHeight,
  JSNumber radius,
);

@JS()
external void rapier_create_capsule_collider(
  JSNumber world,
  JSNumber body,
  JSNumber halfHeight,
  JSNumber radius,
);

// Getters
@JS()
external JSNumber rapier_get_body_position_x(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_get_body_position_y(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_get_body_position_z(JSNumber world, JSNumber body);

@JS()
external JSNumber rapier_get_body_rotation_x(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_get_body_rotation_y(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_get_body_rotation_z(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_get_body_rotation_w(JSNumber world, JSNumber body);

@JS()
external void rapier_set_body_position(
  JSNumber world,
  JSNumber body,
  JSNumber x,
  JSNumber y,
  JSNumber z,
);

@JS()
external void rapier_set_body_rotation(
  JSNumber world,
  JSNumber body,
  JSNumber x,
  JSNumber y,
  JSNumber z,
  JSNumber w,
);
