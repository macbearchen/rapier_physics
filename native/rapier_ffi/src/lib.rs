use rapier3d::na::{Isometry3 as Isometry, Translation3 as Translation};
pub use rapier3d::prelude::*;
use std::alloc::{alloc, dealloc, Layout};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn rapier_version() -> *const c_char {
    use std::sync::OnceLock;
    static VERSION_CSTR: OnceLock<std::ffi::CString> = OnceLock::new();
    VERSION_CSTR
        .get_or_init(|| std::ffi::CString::new(rapier3d::VERSION).unwrap())
        .as_ptr()
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
    gravity: Vector,
    pipeline: PhysicsPipeline,
    integration_parameters: IntegrationParameters,

    islands: IslandManager,
    broad_phase: BroadPhaseBvh,
    narrow_phase: NarrowPhase,

    bodies: RigidBodySet,
    colliders: ColliderSet,

    impulse_joints: ImpulseJointSet,
    multibody_joints: MultibodyJointSet,

    ccd_solver: CCDSolver,
}

#[no_mangle]
pub extern "C" fn rapier_world_create() -> *mut RapierWorld {
    let world = RapierWorld {
        gravity: Vector::new(0.0, -9.81, 0.0),
        pipeline: PhysicsPipeline::new(),
        integration_parameters: IntegrationParameters::default(),

        islands: IslandManager::new(),
        broad_phase: BroadPhaseBvh::new(),
        narrow_phase: NarrowPhase::new(),

        bodies: RigidBodySet::new(),
        colliders: ColliderSet::new(),

        impulse_joints: ImpulseJointSet::new(),
        multibody_joints: MultibodyJointSet::new(),

        ccd_solver: CCDSolver::new(),
    };

    Box::into_raw(Box::new(world))
}

// --- World ---

#[no_mangle]
pub extern "C" fn rapier_world_set_gravity(world: *mut RapierWorld, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    world.gravity = Vector::new(x, y, z);
}

#[no_mangle]
pub extern "C" fn rapier_world_step(world: *mut RapierWorld) {
    let world = unsafe { &mut *world };

    world.pipeline.step(
        world.gravity,
        &world.integration_parameters,
        &mut world.islands,
        &mut world.broad_phase,
        &mut world.narrow_phase,
        &mut world.bodies,
        &mut world.colliders,
        &mut world.impulse_joints,
        &mut world.multibody_joints,
        &mut world.ccd_solver,
        &(),
        &(),
    );
}

#[no_mangle]
pub extern "C" fn rapier_world_destroy(world: *mut RapierWorld) {
    if !world.is_null() {
        unsafe {
            drop(Box::from_raw(world));
        }
    }
}

// --- RigidBody ---

#[no_mangle]
pub extern "C" fn rapier_create_rigid_body(world: *mut RapierWorld, x: f32, y: f32, z: f32, body_type: u8) -> u32 {
    let world = unsafe { &mut *world };

    let builder = match body_type {
        0 => RigidBodyBuilder::dynamic(),
        1 => RigidBodyBuilder::fixed(),
        2 => RigidBodyBuilder::kinematic_position_based(),
        3 => RigidBodyBuilder::kinematic_velocity_based(),
        _ => RigidBodyBuilder::dynamic(),
    };

    let body = builder.translation(Vector::new(x, y, z)).build();

    let handle = world.bodies.insert(body);

    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_world_remove_rigid_body(world: *mut RapierWorld, handle: u32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    world.bodies.remove(
        handle,
        &mut world.islands,
        &mut world.colliders,
        &mut world.impulse_joints,
        &mut world.multibody_joints,
        true,
    );
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
        Vec3 { x: 0.0, y: 0.0, z: 0.0 }
    }
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation(world: *mut RapierWorld, body_handle: u32) -> Quat {
    let world = unsafe { &mut *world };

    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get(body_handle) {
        let rot = body.rotation();

        Quat {
            x: rot.x,
            y: rot.y,
            z: rot.z,
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
pub extern "C" fn rapier_set_body_position(world: *mut RapierWorld, body_handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_translation(Vector::new(x, y, z), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_body_rotation(world: *mut RapierWorld, body_handle: u32, x: f32, y: f32, z: f32, w: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_rotation(rapier3d::prelude::Rotation::from_xyzw(x, y, z, w), true);
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
    world.bodies.get(handle).map(|b| b.rotation().x).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_y(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().y).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_z(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().z).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_body_rotation_w(world: *mut RapierWorld, body_handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    world.bodies.get(handle).map(|b| b.rotation().w).unwrap_or(1.0)
}

#[no_mangle]
pub extern "C" fn rapier_set_body_ccd(world: *mut RapierWorld, body_handle: u32, enabled: bool) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.enable_ccd(enabled);
    }
}

#[no_mangle]
pub extern "C" fn rapier_wake_body(world: *mut RapierWorld, body_handle: u32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.wake_up(true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_body_linear_damping(world: *mut RapierWorld, handle: u32, damping: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_linear_damping(damping);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_body_angular_damping(world: *mut RapierWorld, handle: u32, damping: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_angular_damping(damping);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_add_force(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.add_force(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_add_torque(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.add_torque(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_apply_impulse(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.apply_impulse(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_apply_torque_impulse(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.apply_torque_impulse(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_add_force_at_point(
    world: *mut RapierWorld,
    handle: u32,
    fx: f32,
    fy: f32,
    fz: f32,
    px: f32,
    py: f32,
    pz: f32,
) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.add_force_at_point(vector![fx, fy, fz].into(), point![px, py, pz].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_apply_impulse_at_point(
    world: *mut RapierWorld,
    handle: u32,
    ix: f32,
    iy: f32,
    iz: f32,
    px: f32,
    py: f32,
    pz: f32,
) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.apply_impulse_at_point(vector![ix, iy, iz].into(), point![px, py, pz].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_set_linear_velocity(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_linvel(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_body_set_angular_velocity(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_angvel(vector![x, y, z].into(), true);
    }
}

// --- Collider ---
#[repr(C)]
pub struct ColliderDesc {
    pub shape_type: u32,
    pub hx: f32,
    pub hy: f32,
    pub hz: f32,
    pub radius: f32,
    pub half_height: f32,
    pub friction: f32,
    pub restitution: f32,
    pub density: f32,
    pub local_position_x: f32,
    pub local_position_y: f32,
    pub local_position_z: f32,
    pub local_rotation_x: f32,
    pub local_rotation_y: f32,
    pub local_rotation_z: f32,
    pub local_rotation_w: f32,
}

#[no_mangle]
pub extern "C" fn rapier_create_collider(world: *mut RapierWorld, body_handle: u32, desc: *const ColliderDesc) -> u32 {
    let world = unsafe { &mut *world };
    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    let desc = unsafe { &*desc };

    let mut builder = match desc.shape_type {
        0 => ColliderBuilder::cuboid(desc.hx, desc.hy, desc.hz),
        1 => ColliderBuilder::ball(desc.radius),
        2 => ColliderBuilder::cylinder(desc.half_height, desc.radius),
        3 => ColliderBuilder::cone(desc.half_height, desc.radius),
        4 => ColliderBuilder::capsule_y(desc.half_height, desc.radius),
        _ => ColliderBuilder::cuboid(desc.hx, desc.hy, desc.hz),
    };

    builder = builder
        .friction(desc.friction)
        .restitution(desc.restitution)
        .density(desc.density)
        .position(
            Isometry::from_parts(
                Translation::new(desc.local_position_x, desc.local_position_y, desc.local_position_z),
                rapier3d::prelude::Rotation::from_xyzw(
                    desc.local_rotation_x,
                    desc.local_rotation_y,
                    desc.local_rotation_z,
                    desc.local_rotation_w,
                )
                .into(),
            )
            .into(),
        );

    let collider = builder.build();

    let handle = world
        .colliders
        .insert_with_parent(collider, body_handle, &mut world.bodies);

    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_create_heightfield_collider(
    world: *mut RapierWorld,
    body_handle: u32,
    heights: *const f32,
    nrows: usize,
    ncols: usize,
    sx: f32,
    sy: f32,
    sz: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    let heights_slice = unsafe { std::slice::from_raw_parts(heights, nrows * ncols) };
    let heights_vec = heights_slice.to_vec();

    // Use the Array2 type re-exported by rapier3d/parry3d to ensure type compatibility
    let heights_array = rapier3d::parry::utils::Array2::new(nrows, ncols, heights_vec);

    let collider = ColliderBuilder::heightfield(heights_array, Vector::new(sx, sy, sz)).build();

    let handle = world
        .colliders
        .insert_with_parent(collider, body_handle, &mut world.bodies);

    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_world_remove_collider(world: *mut RapierWorld, handle: u32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world
        .colliders
        .remove(handle, &mut world.islands, &mut world.bodies, true);
}

#[no_mangle]
pub extern "C" fn rapier_set_collider_friction(world: *mut RapierWorld, handle: u32, friction: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_friction(friction);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_collider_restitution(world: *mut RapierWorld, handle: u32, restitution: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_restitution(restitution);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_collider_density(world: *mut RapierWorld, handle: u32, density: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_density(density);
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_collider_position(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_translation(Vector::new(x, y, z));
    }
}

#[no_mangle]
pub extern "C" fn rapier_set_collider_rotation(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32, w: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_rotation(rapier3d::prelude::Rotation::from_xyzw(x, y, z, w));
    }
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_position_x(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.translation().x).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_position_y(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.translation().y).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_position_z(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.translation().z).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_rotation_x(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.rotation().x).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_rotation_y(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.rotation().y).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_rotation_z(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.rotation().z).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_rotation_w(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.rotation().w).unwrap_or(1.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_friction(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.friction()).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_restitution(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.restitution()).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_get_collider_density(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.density()).unwrap_or(0.0)
}

// --- Joint ---

#[no_mangle]
pub extern "C" fn rapier_create_fixed_joint(
    world: *mut RapierWorld,
    body1: u32,
    body2: u32,
    a1x: f32,
    a1y: f32,
    a1z: f32,
    r1x: f32,
    r1y: f32,
    r1z: f32,
    r1w: f32,
    a2x: f32,
    a2y: f32,
    a2z: f32,
    r2x: f32,
    r2y: f32,
    r2z: f32,
    r2w: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let b1 = RigidBodyHandle::from_raw_parts(body1, 0);
    let b2 = RigidBodyHandle::from_raw_parts(body2, 0);

    let joint = FixedJointBuilder::new()
        .local_frame1(
            Isometry::from_parts(
                Translation::new(a1x, a1y, a1z),
                rapier3d::prelude::Rotation::from_xyzw(r1x, r1y, r1z, r1w).into(),
            )
            .into(),
        )
        .local_frame2(
            Isometry::from_parts(
                Translation::new(a2x, a2y, a2z),
                rapier3d::prelude::Rotation::from_xyzw(r2x, r2y, r2z, r2w).into(),
            )
            .into(),
        );

    let handle = world.impulse_joints.insert(b1, b2, joint, true);
    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_create_spherical_joint(
    world: *mut RapierWorld,
    body1: u32,
    body2: u32,
    a1x: f32,
    a1y: f32,
    a1z: f32,
    a2x: f32,
    a2y: f32,
    a2z: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let b1 = RigidBodyHandle::from_raw_parts(body1, 0);
    let b2 = RigidBodyHandle::from_raw_parts(body2, 0);

    let joint = SphericalJointBuilder::new()
        .local_anchor1(Vector::new(a1x, a1y, a1z))
        .local_anchor2(Vector::new(a2x, a2y, a2z));

    let handle = world.impulse_joints.insert(b1, b2, joint, true);
    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_create_revolute_joint(
    world: *mut RapierWorld,
    body1: u32,
    body2: u32,
    vx: f32,
    vy: f32,
    vz: f32,
    a1x: f32,
    a1y: f32,
    a1z: f32,
    a2x: f32,
    a2y: f32,
    a2z: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let b1 = RigidBodyHandle::from_raw_parts(body1, 0);
    let b2 = RigidBodyHandle::from_raw_parts(body2, 0);

    let joint = RevoluteJointBuilder::new(Vector::new(vx, vy, vz))
        .local_anchor1(Vector::new(a1x, a1y, a1z))
        .local_anchor2(Vector::new(a2x, a2y, a2z));

    let handle = world.impulse_joints.insert(b1, b2, joint, true);
    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_create_prismatic_joint(
    world: *mut RapierWorld,
    body1: u32,
    body2: u32,
    vx: f32,
    vy: f32,
    vz: f32,
    a1x: f32,
    a1y: f32,
    a1z: f32,
    a2x: f32,
    a2y: f32,
    a2z: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let b1 = RigidBodyHandle::from_raw_parts(body1, 0);
    let b2 = RigidBodyHandle::from_raw_parts(body2, 0);

    let joint = PrismaticJointBuilder::new(Vector::new(vx, vy, vz))
        .local_anchor1(Vector::new(a1x, a1y, a1z))
        .local_anchor2(Vector::new(a2x, a2y, a2z));

    let handle = world.impulse_joints.insert(b1, b2, joint, true);
    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_world_remove_joint(world: *mut RapierWorld, handle: u32) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(handle, 0);
    world.impulse_joints.remove(handle, true);
}

#[no_mangle]
pub extern "C" fn rapier_joint_configure_revolute_motor(
    world: *mut RapierWorld,
    joint_handle: u32,
    target_pos: f32,
    target_vel: f32,
    stiffness: f32,
    damping: f32,
) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(joint_handle, 0);
    if let Some(joint) = world.impulse_joints.get_mut(handle, true) {
        // Rapier internally aligns the revolute joint's free axis to AngX in the joint frame.
        // Using AngZ was incorrect and caused the motor to have no effect.
        let axis = JointAxis::AngX;
        if stiffness > 0.0 {
            // Position mode: drive to a target angle.
            joint.data.set_motor_position(axis, target_pos, stiffness, damping);
        } else {
            // Velocity mode: drive at a constant angular velocity.
            // Calling both set_motor_position + set_motor_velocity conflicts (they override
            // each other's MotorModel), so we call only the one that matches intent.
            joint.data.set_motor_velocity(axis, target_vel, damping);
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_joint_configure_prismatic_motor(
    world: *mut RapierWorld,
    joint_handle: u32,
    target_pos: f32,
    target_vel: f32,
    stiffness: f32,
    damping: f32,
) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(joint_handle, 0);
    if let Some(joint) = world.impulse_joints.get_mut(handle, true) {
        // Prismatic joint's free axis is LinX in Rapier's joint frame.
        let axis = JointAxis::LinX;
        if stiffness > 0.0 {
            // Position mode: drive to a target linear position.
            joint.data.set_motor_position(axis, target_pos, stiffness, damping);
        } else {
            // Velocity mode: drive at a constant linear velocity.
            joint.data.set_motor_velocity(axis, target_vel, damping);
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_create_generic_joint(
    world: *mut RapierWorld,
    body1: u32,
    body2: u32,
    a1x: f32,
    a1y: f32,
    a1z: f32,
    a2x: f32,
    a2y: f32,
    a2z: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let b1 = RigidBodyHandle::from_raw_parts(body1, 0);
    let b2 = RigidBodyHandle::from_raw_parts(body2, 0);

    let joint = GenericJointBuilder::new(JointAxesMask::empty())
        .local_anchor1(point![a1x, a1y, a1z].into())
        .local_anchor2(point![a2x, a2y, a2z].into())
        .build();

    let handle = world.impulse_joints.insert(b1, b2, joint, true);
    handle.into_raw_parts().0
}

#[no_mangle]
pub extern "C" fn rapier_create_rope_joint(
    world: *mut RapierWorld,
    body1: u32,
    body2: u32,
    a1x: f32,
    a1y: f32,
    a1z: f32,
    a2x: f32,
    a2y: f32,
    a2z: f32,
    max_dist: f32,
) -> u32 {
    let world = unsafe { &mut *world };
    let b1 = RigidBodyHandle::from_raw_parts(body1, 0);
    let b2 = RigidBodyHandle::from_raw_parts(body2, 0);

    let joint = RopeJointBuilder::new(max_dist)
        .local_anchor1(point![a1x, a1y, a1z].into())
        .local_anchor2(point![a2x, a2y, a2z].into());

    let handle = world.impulse_joints.insert(b1, b2, joint, true);
    handle.into_raw_parts().0
}

fn u8_to_joint_axis(axis: u8) -> Option<JointAxis> {
    match axis {
        0 => Some(JointAxis::LinX),
        1 => Some(JointAxis::LinY),
        2 => Some(JointAxis::LinZ),
        3 => Some(JointAxis::AngX),
        4 => Some(JointAxis::AngY),
        5 => Some(JointAxis::AngZ),
        _ => None,
    }
}

#[no_mangle]
pub extern "C" fn rapier_joint_lock_axis(world: *mut RapierWorld, joint_handle: u32, axis: u8, locked: bool) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(joint_handle, 0);
    if let Some(joint) = world.impulse_joints.get_mut(handle, true) {
        if let Some(axis) = u8_to_joint_axis(axis) {
            if locked {
                joint.data.lock_axes(axis.into());
            } else {
                joint.data.locked_axes.remove(axis.into());
            }
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_joint_set_limits(world: *mut RapierWorld, joint_handle: u32, axis: u8, min: f32, max: f32) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(joint_handle, 0);
    if let Some(joint) = world.impulse_joints.get_mut(handle, true) {
        if let Some(axis) = u8_to_joint_axis(axis) {
            joint.data.set_limits(axis, [min, max]);
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_joint_configure_motor(
    world: *mut RapierWorld,
    joint_handle: u32,
    axis: u8,
    target_pos: f32,
    target_vel: f32,
    stiffness: f32,
    damping: f32,
) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(joint_handle, 0);
    if let Some(joint) = world.impulse_joints.get_mut(handle, true) {
        if let Some(axis) = u8_to_joint_axis(axis) {
            joint.data.set_motor_position(axis, target_pos, stiffness, damping);
            joint.data.set_motor_velocity(axis, target_vel, damping);
        }
    }
}

// --- Utility ---

#[no_mangle]
pub extern "C" fn rapier_malloc(size: usize) -> *mut u8 {
    let layout = Layout::from_size_align(size, 8).unwrap();
    unsafe { alloc(layout) }
}

#[no_mangle]
pub extern "C" fn rapier_free(ptr: *mut u8, size: usize) {
    if !ptr.is_null() {
        let layout = Layout::from_size_align(size, 8).unwrap();
        unsafe { dealloc(ptr, layout) }
    }
}
