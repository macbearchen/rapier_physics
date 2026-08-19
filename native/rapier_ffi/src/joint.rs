use crate::types::RapierWorld;
use rapier3d::na::{Isometry3 as Isometry, Translation3 as Translation};
use rapier3d::prelude::*;

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
pub extern "C" fn rapier_joint_create_fixed(
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
pub extern "C" fn rapier_joint_create_spherical(
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
pub extern "C" fn rapier_joint_create_revolute(
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
pub extern "C" fn rapier_joint_create_prismatic(
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
pub extern "C" fn rapier_joint_create_generic(
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
pub extern "C" fn rapier_joint_create_rope(
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

#[no_mangle]
pub extern "C" fn rapier_joint_remove(world: *mut RapierWorld, handle: u32) {
    let world = unsafe { &mut *world };
    let handle = ImpulseJointHandle::from_raw_parts(handle, 0);
    world.impulse_joints.remove(handle, true);
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
        let axis = JointAxis::AngX;
        if stiffness > 0.0 {
            joint.data.set_motor_position(axis, target_pos, stiffness, damping);
        } else {
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
        let axis = JointAxis::LinX;
        if stiffness > 0.0 {
            joint.data.set_motor_position(axis, target_pos, stiffness, damping);
        } else {
            joint.data.set_motor_velocity(axis, target_vel, damping);
        }
    }
}
