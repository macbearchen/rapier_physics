use crate::types::{ColliderDesc, Quat, RapierWorld, Vec3};
use rapier3d::na::{Isometry3 as Isometry, Translation3 as Translation};
use rapier3d::prelude::*;

#[no_mangle]
pub extern "C" fn rapier_collider_create(world: *mut RapierWorld, body_handle: u32, desc: *const ColliderDesc) -> u32 {
    let world = unsafe { &mut *world };
    let body_handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    let desc = unsafe { &*desc };

    let mut builder = match desc.shape_type {
        0 => ColliderBuilder::cuboid(desc.hx, desc.hy, desc.hz),
        1 => ColliderBuilder::ball(desc.radius),
        2 => ColliderBuilder::cylinder(desc.half_height, desc.radius),
        3 => ColliderBuilder::cone(desc.half_height, desc.radius),
        4 => ColliderBuilder::capsule_x(desc.half_height, desc.radius),
        5 => ColliderBuilder::capsule_y(desc.half_height, desc.radius),
        6 => ColliderBuilder::capsule_z(desc.half_height, desc.radius),
        _ => ColliderBuilder::cuboid(desc.hx, desc.hy, desc.hz),
    };

    builder = builder
        .friction(desc.friction)
        .restitution(desc.restitution)
        .density(desc.density)
        .sensor(desc.is_sensor)
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
pub extern "C" fn rapier_collider_create_heightfield(
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
pub extern "C" fn rapier_collider_remove(world: *mut RapierWorld, handle: u32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world
        .colliders
        .remove(handle, &mut world.islands, &mut world.bodies, true);
}

#[no_mangle]
pub extern "C" fn rapier_collider_set_friction(world: *mut RapierWorld, handle: u32, friction: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_friction(friction);
    }
}

#[no_mangle]
pub extern "C" fn rapier_collider_set_restitution(world: *mut RapierWorld, handle: u32, restitution: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_restitution(restitution);
    }
}

#[no_mangle]
pub extern "C" fn rapier_collider_set_density(world: *mut RapierWorld, handle: u32, density: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_density(density);
    }
}

#[no_mangle]
pub extern "C" fn rapier_collider_set_position(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_translation(Vector::new(x, y, z));
    }
}

#[no_mangle]
pub extern "C" fn rapier_collider_set_rotation(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32, w: f32) {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    if let Some(collider) = world.colliders.get_mut(handle) {
        collider.set_rotation(rapier3d::prelude::Rotation::from_xyzw(x, y, z, w));
    }
}

#[no_mangle]
pub extern "C" fn rapier_collider_get_position(world: *mut RapierWorld, handle: u32) -> Vec3 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);

    if let Some(collider) = world.colliders.get(handle) {
        let pos = collider.translation();
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
pub extern "C" fn rapier_collider_get_rotation(world: *mut RapierWorld, handle: u32) -> Quat {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);

    if let Some(collider) = world.colliders.get(handle) {
        let rot = collider.rotation();
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
pub extern "C" fn rapier_collider_get_friction(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.friction()).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_collider_get_restitution(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.restitution()).unwrap_or(0.0)
}

#[no_mangle]
pub extern "C" fn rapier_collider_get_density(world: *mut RapierWorld, handle: u32) -> f32 {
    let world = unsafe { &mut *world };
    let handle = ColliderHandle::from_raw_parts(handle, 0);
    world.colliders.get(handle).map(|c| c.density()).unwrap_or(0.0)
}
