import Cocoa
import FlutterMacOS

// Native function declarations using @_silgen_name to ensure they are visible to the linker
@_silgen_name("rapier_version") @discardableResult func rapier_version() -> UnsafePointer<Int8>?

// --- World ---
@_silgen_name("rapier_world_create") @discardableResult func rapier_world_create() -> UnsafeMutableRawPointer?
@_silgen_name("rapier_world_set_gravity") func rapier_world_set_gravity(_ world: UnsafeMutableRawPointer?, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_world_destroy") func rapier_world_destroy(_ world: UnsafeMutableRawPointer?) -> Void
@_silgen_name("rapier_world_step") func rapier_world_step(_ world: UnsafeMutableRawPointer?) -> Void
@_silgen_name("rapier_world_get_timestep") @discardableResult func rapier_world_get_timestep(_ world: UnsafeMutableRawPointer?) -> Float
@_silgen_name("rapier_world_set_timestep") func rapier_world_set_timestep(_ world: UnsafeMutableRawPointer?, _ dt: Float) -> Void

// --- RigidBody ---
@_silgen_name("rapier_rigid_body_create") @discardableResult func rapier_rigid_body_create(_ world: UnsafeMutableRawPointer?, _ x: Float, _ y: Float, _ z: Float, _ type: UInt8) -> UInt32
@_silgen_name("rapier_rigid_body_remove") func rapier_rigid_body_remove(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Void

@_silgen_name("rapier_rigid_body_get_position_x") @discardableResult func rapier_rigid_body_get_position_x(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_rigid_body_get_position_y") @discardableResult func rapier_rigid_body_get_position_y(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_rigid_body_get_position_z") @discardableResult func rapier_rigid_body_get_position_z(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_rigid_body_get_rotation_x") @discardableResult func rapier_rigid_body_get_rotation_x(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_rigid_body_get_rotation_y") @discardableResult func rapier_rigid_body_get_rotation_y(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_rigid_body_get_rotation_z") @discardableResult func rapier_rigid_body_get_rotation_z(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_rigid_body_get_rotation_w") @discardableResult func rapier_rigid_body_get_rotation_w(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float

@_silgen_name("rapier_rigid_body_set_position") func rapier_rigid_body_set_position(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_rigid_body_set_rotation") func rapier_rigid_body_set_rotation(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ x: Float, _ y: Float, _ z: Float, _ w: Float) -> Void
@_silgen_name("rapier_rigid_body_wake") func rapier_rigid_body_wake(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Void
@_silgen_name("rapier_rigid_body_set_ccd") func rapier_rigid_body_set_ccd(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ enabled: Bool) -> Void
@_silgen_name("rapier_rigid_body_set_linear_damping") func rapier_rigid_body_set_linear_damping(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ damping: Float) -> Void
@_silgen_name("rapier_rigid_body_set_angular_damping") func rapier_rigid_body_set_angular_damping(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ damping: Float) -> Void

@_silgen_name("rapier_rigid_body_add_force") func rapier_rigid_body_add_force(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_rigid_body_add_torque") func rapier_rigid_body_add_torque(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_rigid_body_apply_impulse") func rapier_rigid_body_apply_impulse(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_rigid_body_apply_torque_impulse") func rapier_rigid_body_apply_torque_impulse(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_rigid_body_add_force_at_point") func rapier_rigid_body_add_force_at_point(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ fx: Float, _ fy: Float, _ fz: Float, _ px: Float, _ py: Float, _ pz: Float) -> Void
@_silgen_name("rapier_rigid_body_apply_impulse_at_point") func rapier_rigid_body_apply_impulse_at_point(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ ix: Float, _ iy: Float, _ iz: Float, _ px: Float, _ py: Float, _ pz: Float) -> Void
@_silgen_name("rapier_rigid_body_set_linear_velocity") func rapier_rigid_body_set_linear_velocity(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_rigid_body_set_angular_velocity") func rapier_rigid_body_set_angular_velocity(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void

// --- Collider ---
struct ColliderDesc {
    var shape_type: UInt32
    var hx: Float
    var hy: Float
    var hz: Float
    var radius: Float
    var half_height: Float
    var friction: Float
    var restitution: Float
    var density: Float
    var local_position_x: Float
    var local_position_y: Float
    var local_position_z: Float
    var local_rotation_x: Float
    var local_rotation_y: Float
    var local_rotation_z: Float
    var local_rotation_w: Float
    var is_sensor: Bool
}

@_silgen_name("rapier_collider_create") @discardableResult func rapier_collider_create(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ desc: UnsafePointer<ColliderDesc>?) -> UInt32
@_silgen_name("rapier_collider_create_heightfield") @discardableResult func rapier_collider_create_heightfield(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ heights: UnsafePointer<Float>?, _ nrows: Int, _ ncols: Int, _ sx: Float, _ sy: Float, _ sz: Float) -> UInt32
@_silgen_name("rapier_collider_remove") func rapier_collider_remove(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Void

@_silgen_name("rapier_collider_get_position_x") @discardableResult func rapier_collider_get_position_x(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_position_y") @discardableResult func rapier_collider_get_position_y(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_position_z") @discardableResult func rapier_collider_get_position_z(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_rotation_x") @discardableResult func rapier_collider_get_rotation_x(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_rotation_y") @discardableResult func rapier_collider_get_rotation_y(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_rotation_z") @discardableResult func rapier_collider_get_rotation_z(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_rotation_w") @discardableResult func rapier_collider_get_rotation_w(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_friction") @discardableResult func rapier_collider_get_friction(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_restitution") @discardableResult func rapier_collider_get_restitution(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float
@_silgen_name("rapier_collider_get_density") @discardableResult func rapier_collider_get_density(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Float

@_silgen_name("rapier_collider_set_friction") func rapier_collider_set_friction(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ friction: Float) -> Void
@_silgen_name("rapier_collider_set_restitution") func rapier_collider_set_restitution(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ restitution: Float) -> Void
@_silgen_name("rapier_collider_set_density") func rapier_collider_set_density(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ density: Float) -> Void
@_silgen_name("rapier_collider_set_position") func rapier_collider_set_position(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_collider_set_rotation") func rapier_collider_set_rotation(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float, _ w: Float) -> Void

// --- Joint ---
@_silgen_name("rapier_joint_create_fixed") @discardableResult func rapier_joint_create_fixed(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ r1x: Float, _ r1y: Float, _ r1z: Float, _ r1w: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float, _ r2x: Float, _ r2y: Float, _ r2z: Float, _ r2w: Float) -> UInt32
@_silgen_name("rapier_joint_create_spherical") @discardableResult func rapier_joint_create_spherical(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_joint_create_revolute") @discardableResult func rapier_joint_create_revolute(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ vx: Float, _ vy: Float, _ vz: Float, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_joint_create_prismatic") @discardableResult func rapier_joint_create_prismatic(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ vx: Float, _ vy: Float, _ vz: Float, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_joint_create_generic") @discardableResult func rapier_joint_create_generic(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_joint_create_rope") @discardableResult func rapier_joint_create_rope(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float, _ max_dist: Float) -> UInt32
@_silgen_name("rapier_joint_remove") func rapier_joint_remove(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Void

@_silgen_name("rapier_joint_lock_axis") func rapier_joint_lock_axis(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ axis: UInt8, _ locked: Bool) -> Void
@_silgen_name("rapier_joint_set_limits") func rapier_joint_set_limits(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ axis: UInt8, _ min: Float, _ max: Float) -> Void
@_silgen_name("rapier_joint_configure_motor") func rapier_joint_configure_motor(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ axis: UInt8, _ targetPos: Float, _ targetVel: Float, _ stiffness: Float, _ damping: Float) -> Void
@_silgen_name("rapier_joint_configure_revolute_motor") func rapier_joint_configure_revolute_motor(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ targetPos: Float, _ targetVel: Float, _ stiffness: Float, _ damping: Float) -> Void
@_silgen_name("rapier_joint_configure_prismatic_motor") func rapier_joint_configure_prismatic_motor(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ targetPos: Float, _ targetVel: Float, _ stiffness: Float, _ damping: Float) -> Void

public class RapierPhysicsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "rapier_physics", binaryMessenger: registrar.messenger)
    let instance = RapierPhysicsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // Force ALL symbols to be linked and not stripped by the linker in profile/release mode.
    // We use a condition that is false at runtime but opaque to the compiler during optimization
    // to ensure the linker keeps the references without actually executing crashing code.
    if (ProcessInfo.processInfo.environment["FORCE_RAPIER_KEEP_SYMBOLS"] != nil) {
        let dummyWorld: UnsafeMutableRawPointer? = nil
        rapier_version()

        // --- World ---
        rapier_world_create()
        rapier_world_set_gravity(dummyWorld, 0, 0, 0)
        rapier_world_destroy(dummyWorld)
        rapier_world_step(dummyWorld)
        rapier_world_get_timestep(dummyWorld)
        rapier_world_set_timestep(dummyWorld, 0)

        // --- RigidBody ---
        rapier_rigid_body_create(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_get_position_x(dummyWorld, 0)
        rapier_rigid_body_get_position_y(dummyWorld, 0)
        rapier_rigid_body_get_position_z(dummyWorld, 0)
        rapier_rigid_body_get_rotation_x(dummyWorld, 0)
        rapier_rigid_body_get_rotation_y(dummyWorld, 0)
        rapier_rigid_body_get_rotation_z(dummyWorld, 0)
        rapier_rigid_body_get_rotation_w(dummyWorld, 0)
        rapier_rigid_body_set_position(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_set_rotation(dummyWorld, 0, 0, 0, 0, 0)
        rapier_rigid_body_wake(dummyWorld, 0)
        rapier_rigid_body_set_ccd(dummyWorld, 0, false)
        rapier_rigid_body_set_linear_damping(dummyWorld, 0, 0)
        rapier_rigid_body_set_angular_damping(dummyWorld, 0, 0)
        rapier_rigid_body_add_force(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_add_torque(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_apply_impulse(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_apply_torque_impulse(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_add_force_at_point(dummyWorld, 0, 0, 0, 0, 0, 0, 0)
        rapier_rigid_body_apply_impulse_at_point(dummyWorld, 0, 0, 0, 0, 0, 0, 0)
        rapier_rigid_body_set_linear_velocity(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_set_angular_velocity(dummyWorld, 0, 0, 0, 0)
        rapier_rigid_body_remove(dummyWorld, 0)

        // --- Collider ---
        rapier_collider_create(dummyWorld, 0, nil)
        rapier_collider_create_heightfield(dummyWorld, 0, nil, 0, 0, 0, 0, 0)
        rapier_collider_get_position_x(dummyWorld, 0)
        rapier_collider_get_position_y(dummyWorld, 0)
        rapier_collider_get_position_z(dummyWorld, 0)
        rapier_collider_get_rotation_x(dummyWorld, 0)
        rapier_collider_get_rotation_y(dummyWorld, 0)
        rapier_collider_get_rotation_z(dummyWorld, 0)
        rapier_collider_get_rotation_w(dummyWorld, 0)
        rapier_collider_get_friction(dummyWorld, 0)
        rapier_collider_get_restitution(dummyWorld, 0)
        rapier_collider_get_density(dummyWorld, 0)
        rapier_collider_set_friction(dummyWorld, 0, 0)
        rapier_collider_set_restitution(dummyWorld, 0, 0)
        rapier_collider_set_density(dummyWorld, 0, 0)
        rapier_collider_set_position(dummyWorld, 0, 0, 0, 0)
        rapier_collider_set_rotation(dummyWorld, 0, 0, 0, 0, 0)
        rapier_collider_remove(dummyWorld, 0)

        // --- Joint ---
        rapier_joint_create_fixed(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_create_spherical(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_create_revolute(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_create_prismatic(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_create_generic(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_create_rope(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_lock_axis(dummyWorld, 0, 0, false)
        rapier_joint_set_limits(dummyWorld, 0, 0, 0, 0)
        rapier_joint_configure_motor(dummyWorld, 0, 0, 0, 0, 0, 0)
        rapier_joint_configure_revolute_motor(dummyWorld, 0, 0, 0, 0, 0)
        rapier_joint_configure_prismatic_motor(dummyWorld, 0, 0, 0, 0, 0)
        rapier_joint_remove(dummyWorld, 0)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if (call.method == "getPlatformVersion") {
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
