//! FFI bindings for `DynamicRayCastVehicleController`.
//!
//! ## Lifecycle
//! 1. `rapier_vehicle_create(chassis_handle, up_axis, fwd_axis)` -> `*mut VehicleController`
//! 2. `rapier_vehicle_add_wheel(...)` --- call once per wheel; returns wheel index.
//! 3. Per frame (before `rapier_world_step`):
//!    a. Set per-wheel inputs: `rapier_vehicle_set_steering` / `_engine_force` / `_brake`
//!    b. `rapier_vehicle_update(world, vehicle, dt)`
//! 4. Read back wheel state via `rapier_vehicle_wheel_*` accessors.
//! 5. `rapier_vehicle_destroy(vehicle)` when done.

use crate::types::RapierWorld;
use rapier3d::control::{DynamicRayCastVehicleController, WheelTuning};
use rapier3d::prelude::*;

/// Opaque wrapper stored behind the FFI pointer.
pub struct VehicleController {
    pub vehicle: DynamicRayCastVehicleController,
}

// ----------------------------------------------------------------------------
// Lifecycle
// ----------------------------------------------------------------------------

/// Creates a new vehicle controller for the chassis rigid body identified by
/// `chassis_handle` (generation-0).
///
/// `index_up_axis`      - axis index of local *up* direction (0=x,1=y,2=z).
/// `index_forward_axis` - axis index of local *forward* direction.
#[no_mangle]
pub extern "C" fn rapier_vehicle_create(
    chassis_handle: u32,
    index_up_axis: u32,
    index_forward_axis: u32,
) -> *mut VehicleController {
    let rb_handle = RigidBodyHandle::from_raw_parts(chassis_handle, 0);
    let mut vehicle = DynamicRayCastVehicleController::new(rb_handle);
    vehicle.index_up_axis = index_up_axis as usize;
    vehicle.index_forward_axis = index_forward_axis as usize;
    Box::into_raw(Box::new(VehicleController { vehicle }))
}

/// Frees a vehicle controller previously created with `rapier_vehicle_create`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_destroy(vehicle: *mut VehicleController) {
    if !vehicle.is_null() {
        unsafe { drop(Box::from_raw(vehicle)) };
    }
}

// ----------------------------------------------------------------------------
// Wheel management
// ----------------------------------------------------------------------------

/// Adds a wheel and returns its 0-based index. Tuning params <= 0.0 fall back
/// to `WheelTuning::default()` values.
#[no_mangle]
pub extern "C" fn rapier_vehicle_add_wheel(
    vehicle: *mut VehicleController,
    chassis_connection_x: f32,
    chassis_connection_y: f32,
    chassis_connection_z: f32,
    direction_x: f32,
    direction_y: f32,
    direction_z: f32,
    axle_x: f32,
    axle_y: f32,
    axle_z: f32,
    suspension_rest_length: f32,
    radius: f32,
    suspension_stiffness: f32,
    suspension_compression: f32,
    suspension_damping: f32,
    max_suspension_travel: f32,
    friction_slip: f32,
    max_suspension_force: f32,
) -> u32 {
    let v = unsafe { &mut *vehicle };
    let d = WheelTuning::default();
    let tuning = WheelTuning {
        suspension_stiffness:   if suspension_stiffness > 0.0   { suspension_stiffness }   else { d.suspension_stiffness },
        suspension_compression: if suspension_compression > 0.0 { suspension_compression } else { d.suspension_compression },
        suspension_damping:     if suspension_damping > 0.0     { suspension_damping }     else { d.suspension_damping },
        max_suspension_travel:  if max_suspension_travel > 0.0  { max_suspension_travel }  else { d.max_suspension_travel },
        friction_slip:          if friction_slip > 0.0          { friction_slip }          else { d.friction_slip },
        max_suspension_force:   if max_suspension_force > 0.0   { max_suspension_force }   else { d.max_suspension_force },
        ..d
    };
    let idx = v.vehicle.wheels().len();
    v.vehicle.add_wheel(
        Vector::new(chassis_connection_x, chassis_connection_y, chassis_connection_z),
        Vector::new(direction_x, direction_y, direction_z),
        Vector::new(axle_x, axle_y, axle_z),
        suspension_rest_length,
        radius,
        &tuning,
    );
    idx as u32
}

/// Returns the number of wheels attached to the vehicle.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_count(vehicle: *const VehicleController) -> u32 {
    unsafe { (*vehicle).vehicle.wheels().len() as u32 }
}

// ----------------------------------------------------------------------------
// Per-wheel inputs
// ----------------------------------------------------------------------------

/// Sets the steering angle (radians) for the wheel at `wheel_index`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_set_steering(vehicle: *mut VehicleController, wheel_index: u32, steering: f32) {
    let v = unsafe { &mut *vehicle };
    if let Some(w) = v.vehicle.wheels_mut().get_mut(wheel_index as usize) {
        w.steering = steering;
    }
}

/// Sets the engine force for the wheel at `wheel_index`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_set_engine_force(vehicle: *mut VehicleController, wheel_index: u32, force: f32) {
    let v = unsafe { &mut *vehicle };
    if let Some(w) = v.vehicle.wheels_mut().get_mut(wheel_index as usize) {
        w.engine_force = force;
    }
}

/// Sets the braking force for the wheel at `wheel_index`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_set_brake(vehicle: *mut VehicleController, wheel_index: u32, brake: f32) {
    let v = unsafe { &mut *vehicle };
    if let Some(w) = v.vehicle.wheels_mut().get_mut(wheel_index as usize) {
        w.brake = brake;
    }
}

// ----------------------------------------------------------------------------
// Simulation step
// ----------------------------------------------------------------------------

/// Advances the vehicle simulation by `dt` seconds.
/// **Call before `rapier_world_step`** so impulses are incorporated.
#[no_mangle]
pub extern "C" fn rapier_vehicle_update(world: *mut RapierWorld, vehicle: *mut VehicleController, dt: f32) {
    let world = unsafe { &mut *world };
    let v = unsafe { &mut *vehicle };
    let qp = world.broad_phase.as_query_pipeline_mut(
        world.narrow_phase.query_dispatcher(),
        &mut world.bodies,
        &mut world.colliders,
        QueryFilter::default().exclude_rigid_body(v.vehicle.chassis),
    );
    v.vehicle.update_vehicle(dt, qp);
}

// ----------------------------------------------------------------------------
// Per-wheel state read-back
// ----------------------------------------------------------------------------

/// Returns the spin rotation (radians) of a wheel around its axle.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_rotation(vehicle: *const VehicleController, wheel_index: u32) -> f32 {
    unsafe { (*vehicle).vehicle.wheels().get(wheel_index as usize).map(|w| w.rotation).unwrap_or(0.0) }
}

/// Returns the current steering angle (radians) of a wheel.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_steering(vehicle: *const VehicleController, wheel_index: u32) -> f32 {
    unsafe { (*vehicle).vehicle.wheels().get(wheel_index as usize).map(|w| w.steering).unwrap_or(0.0) }
}

/// Returns the current suspension length of a wheel (metres).
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_suspension_length(vehicle: *const VehicleController, wheel_index: u32) -> f32 {
    unsafe {
        (*vehicle).vehicle.wheels().get(wheel_index as usize)
            .map(|w| w.raycast_info().suspension_length)
            .unwrap_or(0.0)
    }
}

/// Returns true if the wheel is currently in contact with the ground.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_is_in_contact(vehicle: *const VehicleController, wheel_index: u32) -> bool {
    unsafe {
        (*vehicle).vehicle.wheels().get(wheel_index as usize)
            .map(|w| w.raycast_info().is_in_contact)
            .unwrap_or(false)
    }
}

/// Writes the world-space wheel center position into `out_{x,y,z}`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_center(
    vehicle: *const VehicleController, wheel_index: u32,
    out_x: *mut f32, out_y: *mut f32, out_z: *mut f32,
) {
    let c = unsafe {
        (*vehicle).vehicle.wheels().get(wheel_index as usize).map(|w| w.center()).unwrap_or(Vector::ZERO)
    };
    unsafe { *out_x = c.x; *out_y = c.y; *out_z = c.z; }
}

/// Writes the world-space ground contact point into `out_{x,y,z}`.
/// Only meaningful when the wheel is in contact.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_contact_point(
    vehicle: *const VehicleController, wheel_index: u32,
    out_x: *mut f32, out_y: *mut f32, out_z: *mut f32,
) {
    let p = unsafe {
        (*vehicle).vehicle.wheels().get(wheel_index as usize)
            .map(|w| w.raycast_info().contact_point_ws)
            .unwrap_or(Vector::ZERO)
    };
    unsafe { *out_x = p.x; *out_y = p.y; *out_z = p.z; }
}

/// Writes the world-space contact normal into `out_{x,y,z}`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_contact_normal(
    vehicle: *const VehicleController, wheel_index: u32,
    out_x: *mut f32, out_y: *mut f32, out_z: *mut f32,
) {
    let n = unsafe {
        (*vehicle).vehicle.wheels().get(wheel_index as usize)
            .map(|w| w.raycast_info().contact_normal_ws)
            .unwrap_or(Vector::Y)
    };
    unsafe { *out_x = n.x; *out_y = n.y; *out_z = n.z; }
}

/// Returns the current forward speed of the vehicle (m/s).
#[no_mangle]
pub extern "C" fn rapier_vehicle_current_speed(vehicle: *const VehicleController) -> f32 {
    unsafe { (*vehicle).vehicle.current_vehicle_speed }
}

/// Returns the raw collider-handle index of the ground object hit by a wheel, or `u32::MAX`.
#[no_mangle]
pub extern "C" fn rapier_vehicle_wheel_ground_object(vehicle: *const VehicleController, wheel_index: u32) -> u32 {
    unsafe {
        (*vehicle).vehicle.wheels().get(wheel_index as usize)
            .and_then(|w| w.raycast_info().ground_object)
            .map(|h| h.0.into_raw_parts().0)
            .unwrap_or(u32::MAX)
    }
}
