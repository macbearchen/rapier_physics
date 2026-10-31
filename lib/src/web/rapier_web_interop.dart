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
external JSNumber rapier_rigid_body_get_position(JSNumber world, JSNumber body);
@JS()
external JSNumber rapier_rigid_body_get_rotation(JSNumber world, JSNumber body);

@JS()
external JSNumber rapier_collider_get_position(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_rotation(JSNumber world, JSNumber handle);

@JS()
external JSNumber rapier_collider_get_friction(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_restitution(JSNumber world, JSNumber handle);
@JS()
external JSNumber rapier_collider_get_density(JSNumber world, JSNumber handle);

@JS()
external void rapier_rigid_body_set_position(JSNumber world, JSNumber body, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_rigid_body_set_rotation(
  JSNumber world,
  JSNumber body,
  JSNumber x,
  JSNumber y,
  JSNumber z,
  JSNumber w,
);

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
external void rapier_rigid_body_apply_torque_impulse(
  JSNumber world,
  JSNumber handle,
  JSNumber x,
  JSNumber y,
  JSNumber z,
);

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
external void rapier_rigid_body_set_linear_velocity(
  JSNumber world,
  JSNumber handle,
  JSNumber x,
  JSNumber y,
  JSNumber z,
);

@JS()
external void rapier_rigid_body_set_angular_velocity(
  JSNumber world,
  JSNumber handle,
  JSNumber x,
  JSNumber y,
  JSNumber z,
);

@JS()
external void rapier_rigid_body_remove(JSNumber world, JSNumber handle);

@JS()
external void rapier_collider_remove(JSNumber world, JSNumber handle);

@JS()
external void rapier_joint_remove(JSNumber world, JSNumber handle);

// ==========================================
// Kinematic Character Controller
// ==========================================

@JS()
external JSNumber rapier_character_controller_create(JSNumber offset);

@JS()
external void rapier_character_controller_destroy(JSNumber ctrl);

@JS()
external void rapier_character_controller_set_up(JSNumber ctrl, JSNumber x, JSNumber y, JSNumber z);

@JS()
external void rapier_character_controller_set_max_slope(JSNumber ctrl, JSNumber angleRadians);

@JS()
external void rapier_character_controller_set_min_slope(JSNumber ctrl, JSNumber angleRadians);

@JS()
external void rapier_character_controller_set_snap_to_ground(JSNumber ctrl, JSNumber distance, JSBoolean enabled);

@JS()
external void rapier_character_controller_set_autostep(
  JSNumber ctrl,
  JSNumber maxHeight,
  JSNumber minWidth,
  JSBoolean includeDynamicBodies,
);

/// Returns a pointer/index to a Vec3 result on the Wasm heap.
@JS()
external JSNumber rapier_character_controller_move(
  JSNumber world,
  JSNumber ctrl,
  JSNumber colliderHandle,
  JSNumber dx,
  JSNumber dy,
  JSNumber dz,
  JSNumber dt,
);

@JS()
external JSBoolean rapier_character_controller_is_grounded(JSNumber ctrl);

@JS()
external JSBoolean rapier_character_controller_is_on_wall(JSNumber ctrl);

@JS()
external JSBoolean rapier_character_controller_is_on_ceiling(JSNumber ctrl);

/// Helpers to unpack a Vec3 result returned as a pointer from Wasm.
@JS()
external JSNumber rapier_vec3_get_x(JSNumber ptr);

@JS()
external JSNumber rapier_vec3_get_y(JSNumber ptr);

@JS()
external JSNumber rapier_vec3_get_z(JSNumber ptr);

/// Helpers to unpack a Quat result returned as a pointer from Wasm.
@JS()
external JSNumber rapier_quat_get_x(JSNumber ptr);

@JS()
external JSNumber rapier_quat_get_y(JSNumber ptr);

@JS()
external JSNumber rapier_quat_get_z(JSNumber ptr);

@JS()
external JSNumber rapier_quat_get_w(JSNumber ptr);

// Scene Queries
@JS()
external JSNumber rapier_world_cast_ray(
  JSNumber world,
  JSNumber ox,
  JSNumber oy,
  JSNumber oz,
  JSNumber dx,
  JSNumber dy,
  JSNumber dz,
  JSNumber maxToi,
  JSBoolean solid,
  JSNumber excludeCollider,
  JSNumber excludeRigidBody,
);

@JS()
external JSNumber rapier_world_cast_ray_and_get_normal(
  JSNumber world,
  JSNumber ox,
  JSNumber oy,
  JSNumber oz,
  JSNumber dx,
  JSNumber dy,
  JSNumber dz,
  JSNumber maxToi,
  JSBoolean solid,
  JSNumber excludeCollider,
  JSNumber excludeRigidBody,
);

@JS()
external JSNumber rapier_world_cast_shape(
  JSNumber world,
  JSNumber px,
  JSNumber py,
  JSNumber pz,
  JSNumber rx,
  JSNumber ry,
  JSNumber rz,
  JSNumber rw,
  JSNumber vx,
  JSNumber vy,
  JSNumber vz,
  JSNumber shapeType,
  JSNumber hx,
  JSNumber hy,
  JSNumber hz,
  JSNumber radius,
  JSNumber halfHeight,
  JSNumber friction,
  JSNumber restitution,
  JSNumber density,
  JSNumber locX,
  JSNumber locY,
  JSNumber locZ,
  JSNumber rotX,
  JSNumber rotY,
  JSNumber rotZ,
  JSNumber rotW,
  JSBoolean isSensor,
  JSNumber maxToi,
  JSBoolean stopAtPenetration,
  JSNumber excludeCollider,
  JSNumber excludeRigidBody,
);

@JS()
external JSNumber rapier_world_project_point(
  JSNumber world,
  JSNumber px,
  JSNumber py,
  JSNumber pz,
  JSBoolean solid,
  JSNumber excludeCollider,
  JSNumber excludeRigidBody,
);

@JS()
external JSArray rapier_world_intersections_with_point(
  JSNumber world,
  JSNumber px,
  JSNumber py,
  JSNumber pz,
  JSNumber excludeCollider,
  JSNumber excludeRigidBody,
);

@JS()
external JSNumber rapier_world_intersection_with_shape(
  JSNumber world,
  JSNumber px,
  JSNumber py,
  JSNumber pz,
  JSNumber rx,
  JSNumber ry,
  JSNumber rz,
  JSNumber rw,
  JSNumber shapeType,
  JSNumber hx,
  JSNumber hy,
  JSNumber hz,
  JSNumber radius,
  JSNumber halfHeight,
  JSNumber friction,
  JSNumber restitution,
  JSNumber density,
  JSNumber locX,
  JSNumber locY,
  JSNumber locZ,
  JSNumber rotX,
  JSNumber rotY,
  JSNumber rotZ,
  JSNumber rotW,
  JSBoolean isSensor,
  JSNumber excludeCollider,
  JSNumber excludeRigidBody,
);

@JS()
external JSNumber rapier_ray_get_collider(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_rigid_body(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_toi(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_point_x(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_point_y(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_point_z(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_normal_x(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_normal_y(JSNumber ptr);
@JS()
external JSNumber rapier_ray_get_normal_z(JSNumber ptr);
@JS()
external JSBoolean rapier_ray_get_hit(JSNumber ptr);

@JS()
external JSNumber rapier_proj_get_collider(JSNumber ptr);
@JS()
external JSNumber rapier_proj_get_rigid_body(JSNumber ptr);
@JS()
external JSNumber rapier_proj_get_point_x(JSNumber ptr);
@JS()
external JSNumber rapier_proj_get_point_y(JSNumber ptr);
@JS()
external JSNumber rapier_proj_get_point_z(JSNumber ptr);
@JS()
external JSBoolean rapier_proj_get_is_inside(JSNumber ptr);
@JS()
external JSBoolean rapier_proj_get_hit(JSNumber ptr);

// ==========================================
// Dynamic Ray-Cast Vehicle Controller
// ==========================================

@JS()
external JSNumber rapier_vehicle_create(
  JSNumber chassis,
  JSNumber upAxis,
  JSNumber forwardAxis,
);

@JS()
external void rapier_vehicle_destroy(JSNumber vehicle);

@JS()
external JSNumber rapier_vehicle_add_wheel(
  JSNumber vehicle,
  JSNumber connX,
  JSNumber connY,
  JSNumber connZ,
  JSNumber dirX,
  JSNumber dirY,
  JSNumber dirZ,
  JSNumber axleX,
  JSNumber axleY,
  JSNumber axleZ,
  JSNumber restLen,
  JSNumber radius,
  JSNumber stiff,
  JSNumber comp,
  JSNumber damp,
  JSNumber maxTravel,
  JSNumber friction,
  JSNumber maxForce,
);

@JS()
external JSNumber rapier_vehicle_wheel_count(JSNumber vehicle);

@JS()
external void rapier_vehicle_set_steering(
  JSNumber vehicle,
  JSNumber wheelIndex,
  JSNumber steering,
);

@JS()
external void rapier_vehicle_set_engine_force(
  JSNumber vehicle,
  JSNumber wheelIndex,
  JSNumber force,
);

@JS()
external void rapier_vehicle_set_brake(
  JSNumber vehicle,
  JSNumber wheelIndex,
  JSNumber brake,
);

@JS()
external void rapier_vehicle_update(
  JSNumber world,
  JSNumber vehicle,
  JSNumber dt,
);

@JS()
external JSNumber rapier_vehicle_wheel_rotation(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSNumber rapier_vehicle_wheel_steering(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSNumber rapier_vehicle_wheel_suspension_length(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSBoolean rapier_vehicle_wheel_is_in_contact(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSNumber rapier_vehicle_wheel_center(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSNumber rapier_vehicle_wheel_contact_point(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSNumber rapier_vehicle_wheel_contact_normal(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

@JS()
external JSNumber rapier_vehicle_current_speed(JSNumber vehicle);

@JS()
external JSNumber rapier_vehicle_wheel_ground_object(
  JSNumber vehicle,
  JSNumber wheelIndex,
);

