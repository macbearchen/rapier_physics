use rapier3d::prelude::*;

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
    pub gravity: Vector,
    pub pipeline: PhysicsPipeline,
    pub integration_parameters: IntegrationParameters,

    pub islands: IslandManager,
    pub broad_phase: BroadPhaseBvh,
    pub narrow_phase: NarrowPhase,

    pub bodies: RigidBodySet,
    pub colliders: ColliderSet,

    pub query_broad_phase: BroadPhaseBvh,

    pub impulse_joints: ImpulseJointSet,
    pub multibody_joints: MultibodyJointSet,

    pub ccd_solver: CCDSolver,
}

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
    pub is_sensor: bool,
}

#[repr(C)]
#[derive(Copy, Clone, Debug)]
pub struct RayIntersectionC {
    pub collider_handle: u32,
    pub rigid_body_handle: u32,
    pub toi: f32,
    pub point_x: f32,
    pub point_y: f32,
    pub point_z: f32,
    pub normal_x: f32,
    pub normal_y: f32,
    pub normal_z: f32,
    pub hit: bool,
}

#[repr(C)]
#[derive(Copy, Clone, Debug)]
pub struct ShapeCastHitC {
    pub collider_handle: u32,
    pub rigid_body_handle: u32,
    pub toi: f32,
    pub point_x: f32,
    pub point_y: f32,
    pub point_z: f32,
    pub normal_x: f32,
    pub normal_y: f32,
    pub normal_z: f32,
    pub hit: bool,
}

#[repr(C)]
#[derive(Copy, Clone, Debug)]
pub struct PointProjectionC {
    pub collider_handle: u32,
    pub rigid_body_handle: u32,
    pub point_x: f32,
    pub point_y: f32,
    pub point_z: f32,
    pub is_inside: bool,
    pub hit: bool,
}



