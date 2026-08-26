use crate::types::RapierWorld;
use rapier3d::prelude::*;
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn rapier_version() -> *const c_char {
    use std::sync::OnceLock;
    static VERSION_CSTR: OnceLock<std::ffi::CString> = OnceLock::new();
    VERSION_CSTR
        .get_or_init(|| {
            let version_str = format!("{}+20260826", rapier3d::VERSION);
            std::ffi::CString::new(version_str).unwrap()
        })
        .as_ptr()
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

        query_broad_phase: BroadPhaseBvh::new(),

        impulse_joints: ImpulseJointSet::new(),
        multibody_joints: MultibodyJointSet::new(),

        ccd_solver: CCDSolver::new(),
    };

    Box::into_raw(Box::new(world))
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
pub extern "C" fn rapier_world_get_timestep(world: *mut RapierWorld) -> f32 {
    let world = unsafe { &mut *world };
    world.integration_parameters.dt
}

#[no_mangle]
pub extern "C" fn rapier_world_set_timestep(world: *mut RapierWorld, dt: f32) {
    let world = unsafe { &mut *world };
    world.integration_parameters.dt = dt;
}
