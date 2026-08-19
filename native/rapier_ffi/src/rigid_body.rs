use crate::types::{Quat, RapierWorld, Vec3};
use rapier3d::prelude::*;

#[no_mangle]
pub extern "C" fn rapier_rigid_body_create(world: *mut RapierWorld, x: f32, y: f32, z: f32, body_type: u8) -> u32 {
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
pub extern "C" fn rapier_rigid_body_remove(world: *mut RapierWorld, handle: u32) {
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
pub extern "C" fn rapier_rigid_body_get_position(world: *mut RapierWorld, body_handle: u32) -> Vec3 {
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
pub extern "C" fn rapier_rigid_body_get_rotation(world: *mut RapierWorld, body_handle: u32) -> Quat {
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
pub extern "C" fn rapier_rigid_body_set_position(world: *mut RapierWorld, body_handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);

    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_translation(Vector::new(x, y, z), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_set_rotation(
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
        body.set_rotation(rapier3d::prelude::Rotation::from_xyzw(x, y, z, w), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_set_ccd(world: *mut RapierWorld, body_handle: u32, enabled: bool) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.enable_ccd(enabled);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_wake(world: *mut RapierWorld, body_handle: u32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(body_handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.wake_up(true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_set_linear_damping(world: *mut RapierWorld, handle: u32, damping: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_linear_damping(damping);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_set_angular_damping(world: *mut RapierWorld, handle: u32, damping: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_angular_damping(damping);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_add_force(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.add_force(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_add_torque(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.add_torque(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_apply_impulse(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.apply_impulse(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_apply_torque_impulse(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.apply_torque_impulse(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_add_force_at_point(
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
pub extern "C" fn rapier_rigid_body_apply_impulse_at_point(
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
pub extern "C" fn rapier_rigid_body_set_linear_velocity(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_linvel(vector![x, y, z].into(), true);
    }
}

#[no_mangle]
pub extern "C" fn rapier_rigid_body_set_angular_velocity(world: *mut RapierWorld, handle: u32, x: f32, y: f32, z: f32) {
    let world = unsafe { &mut *world };
    let handle = RigidBodyHandle::from_raw_parts(handle, 0);
    if let Some(body) = world.bodies.get_mut(handle) {
        body.set_angvel(vector![x, y, z].into(), true);
    }
}
