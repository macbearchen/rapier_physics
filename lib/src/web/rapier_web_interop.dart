// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

@JS()
external JSPromise rapier_init();

@JS()
external JSString rapier_version();

@JS()
external JSNumber rapier_world_create();

@JS()
external void rapier_world_destroy(JSNumber world);

@JS()
external void rapier_world_set_gravity(JSNumber world, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_world_step(JSNumber world);

@JS()
external JSNumber rapier_world_get_timestep(JSNumber world);

@JS()
external void rapier_world_set_timestep(JSNumber world, JSNumber dt);

@JS()
external JSNumber rapier_rigid_body_create(JSNumber world, JSNumber x, JSNumber y, JSNumber z, JSNumber type);

@JS()
external JSNumber rapier_collider_create(
  JSNumber world,
  JSNumber body,
  JSNumber shapeType,
  JSNumber hx,
  JSNumber hy,
  JSNumber hz,
  JSNumber radius,
  JSNumber halfHeight,
  JSNumber friction,
  JSNumber restitution,
  JSNumber density,
  JSNumber localPositionX,
  JSNumber localPositionY,
  JSNumber localPositionZ,
  JSNumber localRotationX,
  JSNumber localRotationY,
  JSNumber localRotationZ,
  JSNumber localRotationW,
  JSBoolean isSensor,
);

@JS()
external JSNumber rapier_collider_create_heightfield(
  JSNumber world,
  JSNumber body,
  JSFloat32Array heights,
  JSNumber nrows,
  JSNumber ncols,
  JSNumber sx,
  JSNumber sy,
  JSNumber sz,
);

@JS()
external JSNumber rapier_malloc(JSNumber size);

@JS()
external void rapier_free(JSNumber ptr, JSNumber size);

@JS()
external JSNumber rapier_joint_create_fixed(
  JSNumber world,
  JSNumber body1,
  JSNumber body2,
  JSNumber a1x,
  JSNumber a1y,
  JSNumber a1z,
  JSNumber r1x,
  JSNumber r1y,
  JSNumber r1z,
  JSNumber r1w,
  JSNumber a2x,
  JSNumber a2y,
  JSNumber a2z,
  JSNumber r2x,
  JSNumber r2y,
  JSNumber r2z,
  JSNumber r2w,
);

@JS()
external JSNumber rapier_joint_create_spherical(
  JSNumber world,
  JSNumber body1,
  JSNumber body2,
  JSNumber a1x,
  JSNumber a1y,
  JSNumber a1z,
  JSNumber a2x,
  JSNumber a2y,
  JSNumber a2z,
);

@JS()
external JSNumber rapier_joint_create_revolute(
  JSNumber world,
  JSNumber body1,
  JSNumber body2,
  JSNumber vx,
  JSNumber vy,
  JSNumber vz,
  JSNumber a1x,
  JSNumber a1y,
  JSNumber a1z,
  JSNumber a2x,
  JSNumber a2y,
  JSNumber a2z,
);

@JS()
external JSNumber rapier_joint_create_prismatic(
  JSNumber world,
  JSNumber body1,
  JSNumber body2,
  JSNumber vx,
  JSNumber vy,
  JSNumber vz,
  JSNumber a1x,
  JSNumber a1y,
  JSNumber a1z,
  JSNumber a2x,
  JSNumber a2y,
  JSNumber a2z,
);

@JS()
external JSNumber rapier_joint_create_generic(
  JSNumber world,
  JSNumber body1,
  JSNumber body2,
  JSNumber a1x,
  JSNumber a1y,
  JSNumber a1z,
  JSNumber a2x,
  JSNumber a2y,
  JSNumber a2z,
);

@JS()
external JSNumber rapier_joint_create_rope(
  JSNumber world,
  JSNumber body1,
  JSNumber body2,
  JSNumber a1x,
  JSNumber a1y,
  JSNumber a1z,
  JSNumber a2x,
  JSNumber a2y,
  JSNumber a2z,
  JSNumber maxDist,
);

@JS()
external void rapier_joint_lock_axis(JSNumber world, JSNumber joint, JSNumber axis, JSBoolean locked);

@JS()
external void rapier_joint_set_limits(JSNumber world, JSNumber joint, JSNumber axis, JSNumber min, JSNumber max);

@JS()
external void rapier_joint_configure_motor(
  JSNumber world,
  JSNumber joint,
  JSNumber axis,
  JSNumber targetPos,
  JSNumber targetVel,
  JSNumber stiffness,
  JSNumber damping,
);

@JS()
external void rapier_joint_configure_revolute_motor(
  JSNumber world,
  JSNumber joint,
  JSNumber targetPos,
  JSNumber targetVel,
  JSNumber stiffness,
  JSNumber damping,
);

@JS()
external void rapier_joint_configure_prismatic_motor(
  JSNumber world,
  JSNumber joint,
  JSNumber targetPos,
  JSNumber targetVel,
  JSNumber stiffness,
  JSNumber damping,
);

// Getters
@JS()
external JSNumber rapier_rigid_body_get_position_x(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_rigid_body_get_position_y(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_rigid_body_get_position_z(JSNumber world, JSNumber body);

@JS()
external JSNumber rapier_rigid_body_get_rotation_x(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_rigid_body_get_rotation_y(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_rigid_body_get_rotation_z(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_rigid_body_get_rotation_w(JSNumber world, JSNumber body);

@JS()
external JSNumber rapier_collider_get_position_x(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_position_y(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_position_z(JSNumber world, JSNumber handle);

@JS()
external JSNumber rapier_collider_get_rotation_x(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_rotation_y(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_rotation_z(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_rotation_w(JSNumber world, JSNumber handle);

@JS()
external JSNumber rapier_collider_get_friction(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_restitution(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_density(JSNumber world, JSNumber handle);

@JS()
external void rapier_rigid_body_set_position(JSNumber world, JSNumber body, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_set_rotation(JSNumber world, JSNumber body, JSNumber x, JSNumber y, JSNumber z, JSNumber w);

@JS()
external void rapier_rigid_body_wake(JSNumber world, JSNumber body);

@JS()
external void rapier_rigid_body_set_ccd(JSNumber world, JSNumber body, JSBoolean enabled);

@JS()
external void rapier_collider_set_friction(JSNumber world, JSNumber handle, JSNumber friction);

@JS()
external void rapier_collider_set_restitution(JSNumber world, JSNumber handle, JSNumber restitution);

@JS()
external void rapier_collider_set_density(JSNumber world, JSNumber handle, JSNumber density);

@JS()
external void rapier_collider_set_position(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_collider_set_rotation(
  JSNumber world,
  JSNumber handle,
  JSNumber x,
  JSNumber y,
  JSNumber z,
  JSNumber w,
);

@JS()
external void rapier_rigid_body_set_linear_damping(JSNumber world, JSNumber handle, JSNumber damping);

@JS()
external void rapier_rigid_body_set_angular_damping(JSNumber world, JSNumber handle, JSNumber damping);

@JS()
external void rapier_rigid_body_add_force(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_add_torque(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_apply_impulse(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_apply_torque_impulse(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_add_force_at_point(
  JSNumber world,
  JSNumber handle,
  JSNumber fx,
  JSNumber fy,
  JSNumber fz,
  JSNumber px,
  JSNumber py,
  JSNumber pz,
);

@JS()
external void rapier_rigid_body_apply_impulse_at_point(
  JSNumber world,
  JSNumber handle,
  JSNumber ix,
  JSNumber iy,
  JSNumber iz,
  JSNumber px,
  JSNumber py,
  JSNumber pz,
);

@JS()
external void rapier_rigid_body_set_linear_velocity(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_set_angular_velocity(JSNumber world, JSNumber handle, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_remove(JSNumber world, JSNumber handle);

@JS()
external void rapier_collider_remove(JSNumber world, JSNumber handle);

@JS()
external void rapier_joint_remove(JSNumber world, JSNumber handle);
