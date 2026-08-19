use crate::types::{RapierWorld, Vec3};
use rapier3d::control::{CharacterAutostep, CharacterLength, KinematicCharacterController};
use rapier3d::prelude::*;

pub struct CharacterController {
    controller: KinematicCharacterController,
    /// Result of the last `move_shape` call.
    grounded: bool,
    on_wall: bool,
    on_ceiling: bool,
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_create(offset: f32) -> *mut CharacterController {
    let mut controller = KinematicCharacterController::default();
    controller.offset = CharacterLength::Absolute(offset);
    // Slide along slopes instead of stopping
    controller.slide = true;
    let ctrl = CharacterController {
        controller,
        grounded: false,
        on_wall: false,
        on_ceiling: false,
    };
    Box::into_raw(Box::new(ctrl))
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_destroy(ctrl: *mut CharacterController) {
    if !ctrl.is_null() {
        unsafe { drop(Box::from_raw(ctrl)) };
    }
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_set_up(ctrl: *mut CharacterController, x: f32, y: f32, z: f32) {
    let ctrl = unsafe { &mut *ctrl };
    ctrl.controller.up = Vector::new(x, y, z).normalize().into();
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_set_max_slope(ctrl: *mut CharacterController, angle_radians: f32) {
    let ctrl = unsafe { &mut *ctrl };
    ctrl.controller.max_slope_climb_angle = angle_radians;
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_set_min_slope(ctrl: *mut CharacterController, angle_radians: f32) {
    let ctrl = unsafe { &mut *ctrl };
    ctrl.controller.min_slope_slide_angle = angle_radians;
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_set_snap_to_ground(
    ctrl: *mut CharacterController,
    distance: f32,
    enabled: bool,
) {
    let ctrl = unsafe { &mut *ctrl };
    if enabled {
        ctrl.controller.snap_to_ground = Some(CharacterLength::Absolute(distance));
    } else {
        ctrl.controller.snap_to_ground = None;
    }
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_set_autostep(
    ctrl: *mut CharacterController,
    max_height: f32,
    min_width: f32,
    include_dynamic_bodies: bool,
) {
    let ctrl = unsafe { &mut *ctrl };
    if max_height > 0.0 {
        ctrl.controller.autostep = Some(CharacterAutostep {
            max_height: CharacterLength::Absolute(max_height),
            min_width: CharacterLength::Absolute(min_width),
            include_dynamic_bodies,
        });
    } else {
        ctrl.controller.autostep = None;
    }
}

/// Compute the corrected movement for a kinematic character.
///
/// - `world`          : pointer to the RapierWorld
/// - `ctrl`           : pointer to the CharacterController
/// - `collider_handle`: the character's own collider (excluded from the sweep)
/// - `dx, dy, dz`     : desired movement this frame
/// - `dt`             : simulation timestep
///
/// Returns the corrected movement Vec3. Call `rapier_character_controller_is_grounded`
/// etc. after this to query contact state.
#[no_mangle]
pub extern "C" fn rapier_character_controller_move(
    world: *mut RapierWorld,
    ctrl: *mut CharacterController,
    collider_handle: u32,
    dx: f32,
    dy: f32,
    dz: f32,
    dt: f32,
) -> Vec3 {
    let world = unsafe { &mut *world };
    let ctrl = unsafe { &mut *ctrl };

    let handle = ColliderHandle::from_raw_parts(collider_handle, 0);

    // Retrieve the current shape + position from the collider.
    let (shape, shape_pos) = if let Some(collider) = world.colliders.get(handle) {
        (collider.shared_shape().clone(), *collider.position())
    } else {
        ctrl.grounded = false;
        ctrl.on_wall = false;
        ctrl.on_ceiling = false;
        return Vec3 { x: 0.0, y: 0.0, z: 0.0 };
    };

    // Build a query filter that excludes the character's own collider.
    let filter = QueryFilter::default().exclude_collider(handle);

    let query_pipeline = world.broad_phase.as_query_pipeline(
        world.narrow_phase.query_dispatcher(),
        &world.bodies,
        &world.colliders,
        filter,
    );

    let desired = Vector::new(dx, dy, dz);

    let mut collisions = Vec::new();
    let result = ctrl.controller.move_shape(
        dt,
        &query_pipeline,
        shape.as_ref(),
        &shape_pos,
        desired,
        |collision| collisions.push(collision.clone()),
    );

    let mass = world
        .colliders
        .get(handle)
        .and_then(|c| c.parent())
        .and_then(|h| world.bodies.get(h))
        .map(|b| b.mass())
        .unwrap_or(1.0);

    let mut query_pipeline_mut = world.broad_phase.as_query_pipeline_mut(
        world.narrow_phase.query_dispatcher(),
        &mut world.bodies,
        &mut world.colliders,
        filter,
    );

    ctrl.controller.solve_character_collision_impulses(
        dt,
        &mut query_pipeline_mut,
        shape.as_ref(),
        mass,
        &collisions,
    );

    // Cache grounded/wall/ceiling for query functions.
    ctrl.grounded = result.grounded;
    let translation_len = (result.translation.x * result.translation.x
        + result.translation.y * result.translation.y
        + result.translation.z * result.translation.z)
        .sqrt();
    let desired_len = (dx * dx + dy * dy + dz * dz).sqrt();
    ctrl.on_wall = translation_len < desired_len * 0.9 && !result.grounded;
    let up = ctrl.controller.up;
    let tr = result.translation;
    ctrl.on_ceiling =
        (up.x * tr.x + up.y * tr.y + up.z * tr.z) < 0.0 && ((-up.x) * dx + (-up.y) * dy + (-up.z) * dz) > 0.0;

    Vec3 {
        x: result.translation.x,
        y: result.translation.y,
        z: result.translation.z,
    }
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_is_grounded(ctrl: *mut CharacterController) -> bool {
    unsafe { (*ctrl).grounded }
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_is_on_wall(ctrl: *mut CharacterController) -> bool {
    unsafe { (*ctrl).on_wall }
}

#[no_mangle]
pub extern "C" fn rapier_character_controller_is_on_ceiling(ctrl: *mut CharacterController) -> bool {
    unsafe { (*ctrl).on_ceiling }
}
