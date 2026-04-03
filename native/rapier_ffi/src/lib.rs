pub use nalgebra::{vector, Vector3, Quaternion};
pub use rapier3d::prelude::*;
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn rapier_version() -> *const c_char {
    "0.18.0\0".as_ptr() as *const c_char
}

#[repr(C)]
pub struct Vec3 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}

#[repr(C)]
pub struct Quat {
    pub x: f32,
    pub y: f32,
    pub z: f32,
    pub w: f32,
}

pub struct RapierWorld {
    gravity: Vector<Real>,
    pipeline: PhysicsPipeline,
    integration_parameters: IntegrationParameters,

    islands: IslandManager,
    broad_phase: BroadPhase,
    narrow_phase: NarrowPhase,

    bodies: RigidBodySet,
    colliders: ColliderSet,

    impulse_joints: ImpulseJointSet,
    multibody_joints: MultibodyJointSet,

    ccd_solver: CCDSolver,
    query_pipeline: QueryPipeline,
}

#[no_mangle]
pub extern "C" fn rapier_world_create() -> *mut RapierWorld {
    let world = RapierWorld {
        gravity: vector![0.0, -9.81, 0.0],
        pipeline: PhysicsPipeline::new(),
        integration_parameters: IntegrationParameters::default(),

        islands: IslandManager::new(),
        broad_phase: BroadPhase::new(),
        narrow_phase: NarrowPhase::new(),

        bodies: RigidBodySet::new(),
        colliders: ColliderSet::new(),

        impulse_joints: ImpulseJointSet::new(),
        multibody_joints: MultibodyJointSet::new(),

        ccd_solver: CCDSolver::new(),
        query_pipeline: QueryPipeline::new(),
    };

    Box::into_raw(Box::new(world))
}

#[no_mangle]
pub extern "C" fn rapier_world_set_gravity(world: *mut RapierWorld, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    world.gravity = vector![x, y, z];
}

#[no_mangle]
pub extern "C" fn rapier_world_destroy(world: *mut RapierWorld) {
    if !world.is_null() {
        unsafe {
            drop(Box::from_raw(world));
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_world_step(world: *mut RapierWorld) {
    let world = unsafe { &mut *world };

    world.pipeline.step(
        &world.gravity,
        &world.integration_parameters,
        &mut world.islands,
        &mut world.broad_phase,
        &mut world.narrow_phase,
        &mut world.bodies,
        &mut world.colliders,
        &mut world.impulse_joints,
        &mut world.multibody_joints,
        &mut world.ccd_solver,
        Some(&mut world.query_pipeline),
        &(),
        &(),
    );
}

#[no_mangle]
pub extern "C" fn rapier_create_rigid_body(
    world: *mut RapierWorld,
    x: f32,
    y: f32,
    z: f32,
    body_type: u8,
) -> u32 {
    let world = unsafe { &mut *world };

    let builder = match body_type {
        0 => RigidBodyBuilder::dynamic(),
        1 => RigidBodyBuilder::fixed(),
        2 => RigidBodyBuilder::kinematic_position_based(),
        3 => RigidBodyBuilder::kinematic_velocity_based(),
        _ => RigidBodyBuilder::dynamic(),
    };

    let body = builder.translation(vector![x, y, z]).build();

    let handle = world.bodies.insert(body);

    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_create_box_collider(
    world: *mut RapierWorld,
    body_handle: u32,
    hx: f32,
    hy: f32,
    hz: f32,
) {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    let collider = ColliderBuilder::cuboid(hx, hy, hz).build();

    world
        .colliders
        .insert_with_parent(collider, body_handle, &mut world.bodies);
}

#[no_mangle]
pub extern "C" fn rapier_create_sphere_collider(
    world: *mut RapierWorld,
    body_handle: u32,
    radius: f32,
) {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    let collider = ColliderBuilder::ball(radius).build();

    world
        .colliders
        .insert_with_parent(collider, body_handle, &mut world.bodies);
}

#[no_mangle]
pub extern "C" fn rapier_create_cylinder_collider(
    world: *mut RapierWorld,
    body_handle: u32,
    half_height: f32,
    radius: f32,
) {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    let collider = ColliderBuilder::cylinder(half_height, radius).build();

    world
        .colliders
        .insert_with_parent(collider, body_handle, &mut world.bodies);
}

#[no_mangle]
pub extern "C" fn rapier_create_capsule_collider(
    world: *mut RapierWorld,
    body_handle: u32,
    half_height: f32,
    radius: f32,
) {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    let collider = ColliderBuilder::capsule_y(half_height, radius).build();

    world
        .colliders
        .insert_with_parent(collider, body_handle, &mut world.bodies);
}

#[no_mangle]
pub extern "C" fn rapier_get_body_position(world: *mut RapierWorld, body_handle: u32) -> Vec3 {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get(body_handle) {
        let pos = body.translation();

        Vec3 {
            x: pos.x,
            y: pos.y,
            z: pos.z,
        }
    } else {
        Vec3 {
            x: 0.0,
            y: 0.0,
            z: 0.0,
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation(world: *mut RapierWorld, body_handle: u32) -> Quat {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get(body_handle) {
        let rot = body.rotation();

        Quat {
            x: rot.i,
            y: rot.j,
            z: rot.k,
            w: rot.w,
        }
    } else {
        Quat {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            w: 1.0,
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_body_position(
    world: *mut RapierWorld,
    body_handle: u32,
    x: f32,
    y: f32,
    z: f32,
) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_translation(vector![x, y, z], true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_body_rotation(
    world: *mut RapierWorld,
    body_handle: u32,
    x: f32,
    y: f32,
    z: f32,
    w: f32,
) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_rotation(Rotation::from_quaternion(Quaternion::new(w, x, y, z)), true);
    }
}

// WASM-friendly getters (returning f32 instead of structs)
#[no_mangle]
pub extern "C" fn rapier_get_body_position_x(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.translation().x).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_position_y(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.translation().y).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_position_z(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.translation().z).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_x(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().i).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_y(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().j).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_z(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().k).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_w(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().w).unwrap_or(1.0)
}
