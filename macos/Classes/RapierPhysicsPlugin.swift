import Cocoa
import FlutterMacOS

// Native function declarations using @_silgen_name to ensure they are visible to the linker
@_silgen_name("rapier_version") @discardableResult func rapier_version() -> UnsafePointer<Int8>?
@_silgen_name("rapier_world_create") @discardableResult func rapier_world_create() -> UnsafeMutableRawPointer?
@_silgen_name("rapier_world_set_gravity") func rapier_world_set_gravity(_ world: UnsafeMutableRawPointer?, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_world_destroy") func rapier_world_destroy(_ world: UnsafeMutableRawPointer?) -> Void
@_silgen_name("rapier_world_step") func rapier_world_step(_ world: UnsafeMutableRawPointer?) -> Void
@_silgen_name("rapier_create_rigid_body") @discardableResult func rapier_create_rigid_body(_ world: UnsafeMutableRawPointer?, _ x: Float, _ y: Float, _ z: Float, _ type: UInt8) -> UInt32
@_silgen_name("rapier_create_box_collider") @discardableResult func rapier_create_box_collider(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ hx: Float, _ hy: Float, _ hz: Float) -> UInt32
@_silgen_name("rapier_create_sphere_collider") @discardableResult func rapier_create_sphere_collider(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ radius: Float) -> UInt32
@_silgen_name("rapier_create_cylinder_collider") @discardableResult func rapier_create_cylinder_collider(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ hh: Float, _ r: Float) -> UInt32
@_silgen_name("rapier_create_cone_collider") @discardableResult func rapier_create_cone_collider(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ hh: Float, _ r: Float) -> UInt32
@_silgen_name("rapier_create_capsule_collider") @discardableResult func rapier_create_capsule_collider(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ hh: Float, _ r: Float) -> UInt32
@_silgen_name("rapier_create_heightfield_collider") @discardableResult func rapier_create_heightfield_collider(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ heights: UnsafePointer<Float>?, _ nrows: Int, _ ncols: Int, _ sx: Float, _ sy: Float, _ sz: Float) -> UInt32
@_silgen_name("rapier_get_body_position_x") @discardableResult func rapier_get_body_position_x(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_get_body_position_y") @discardableResult func rapier_get_body_position_y(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_get_body_position_z") @discardableResult func rapier_get_body_position_z(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_get_body_rotation_x") @discardableResult func rapier_get_body_rotation_x(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_get_body_rotation_y") @discardableResult func rapier_get_body_rotation_y(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_get_body_rotation_z") @discardableResult func rapier_get_body_rotation_z(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_get_body_rotation_w") @discardableResult func rapier_get_body_rotation_w(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Float
@_silgen_name("rapier_set_body_position") func rapier_set_body_position(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_set_body_rotation") func rapier_set_body_rotation(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ x: Float, _ y: Float, _ z: Float, _ w: Float) -> Void
@_silgen_name("rapier_create_fixed_joint") @discardableResult func rapier_create_fixed_joint(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ r1x: Float, _ r1y: Float, _ r1z: Float, _ r1w: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float, _ r2x: Float, _ r2y: Float, _ r2z: Float, _ r2w: Float) -> UInt32
@_silgen_name("rapier_create_spherical_joint") @discardableResult func rapier_create_spherical_joint(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_create_revolute_joint") @discardableResult func rapier_create_revolute_joint(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ vx: Float, _ vy: Float, _ vz: Float, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_create_prismatic_joint") @discardableResult func rapier_create_prismatic_joint(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ vx: Float, _ vy: Float, _ vz: Float, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_create_generic_joint") @discardableResult func rapier_create_generic_joint(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float) -> UInt32
@_silgen_name("rapier_create_rope_joint") @discardableResult func rapier_create_rope_joint(_ world: UnsafeMutableRawPointer?, _ b1: UInt32, _ b2: UInt32, _ a1x: Float, _ a1y: Float, _ a1z: Float, _ a2x: Float, _ a2y: Float, _ a2z: Float, _ max_dist: Float) -> UInt32
@_silgen_name("rapier_joint_lock_axis") func rapier_joint_lock_axis(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ axis: UInt8, _ locked: Bool) -> Void
@_silgen_name("rapier_joint_set_limits") func rapier_joint_set_limits(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ axis: UInt8, _ min: Float, _ max: Float) -> Void
@_silgen_name("rapier_joint_configure_motor") func rapier_joint_configure_motor(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ axis: UInt8, _ targetPos: Float, _ targetVel: Float, _ stiffness: Float, _ damping: Float) -> Void
@_silgen_name("rapier_joint_configure_revolute_motor") func rapier_joint_configure_revolute_motor(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ targetPos: Float, _ targetVel: Float, _ stiffness: Float, _ damping: Float) -> Void
@_silgen_name("rapier_joint_configure_prismatic_motor") func rapier_joint_configure_prismatic_motor(_ world: UnsafeMutableRawPointer?, _ joint: UInt32, _ targetPos: Float, _ targetVel: Float, _ stiffness: Float, _ damping: Float) -> Void
@_silgen_name("rapier_wake_body") func rapier_wake_body(_ world: UnsafeMutableRawPointer?, _ body: UInt32) -> Void
@_silgen_name("rapier_set_body_ccd") func rapier_set_body_ccd(_ world: UnsafeMutableRawPointer?, _ body: UInt32, _ enabled: Bool) -> Void
@_silgen_name("rapier_set_collider_friction") func rapier_set_collider_friction(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ friction: Float) -> Void
@_silgen_name("rapier_set_collider_restitution") func rapier_set_collider_restitution(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ restitution: Float) -> Void
@_silgen_name("rapier_set_collider_density") func rapier_set_collider_density(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ density: Float) -> Void
@_silgen_name("rapier_set_body_linear_damping") func rapier_set_body_linear_damping(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ damping: Float) -> Void
@_silgen_name("rapier_set_body_angular_damping") func rapier_set_body_angular_damping(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ damping: Float) -> Void
@_silgen_name("rapier_body_add_force") func rapier_body_add_force(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_body_add_torque") func rapier_body_add_torque(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_body_apply_impulse") func rapier_body_apply_impulse(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_body_apply_torque_impulse") func rapier_body_apply_torque_impulse(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_body_add_force_at_point") func rapier_body_add_force_at_point(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ fx: Float, _ fy: Float, _ fz: Float, _ px: Float, _ py: Float, _ pz: Float) -> Void
@_silgen_name("rapier_body_apply_impulse_at_point") func rapier_body_apply_impulse_at_point(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ ix: Float, _ iy: Float, _ iz: Float, _ px: Float, _ py: Float, _ pz: Float) -> Void
@_silgen_name("rapier_body_set_linear_velocity") func rapier_body_set_linear_velocity(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_body_set_angular_velocity") func rapier_body_set_angular_velocity(_ world: UnsafeMutableRawPointer?, _ handle: UInt32, _ x: Float, _ y: Float, _ z: Float) -> Void
@_silgen_name("rapier_world_remove_rigid_body") func rapier_world_remove_rigid_body(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Void
@_silgen_name("rapier_world_remove_collider") func rapier_world_remove_collider(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Void
@_silgen_name("rapier_world_remove_joint") func rapier_world_remove_joint(_ world: UnsafeMutableRawPointer?, _ handle: UInt32) -> Void

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
        rapier_world_create()
        rapier_world_set_gravity(dummyWorld, 0, 0, 0)
        rapier_world_destroy(dummyWorld)
        rapier_world_step(dummyWorld)
        rapier_create_rigid_body(dummyWorld, 0, 0, 0, 0)
        rapier_create_box_collider(dummyWorld, 0, 0, 0, 0)
        rapier_create_sphere_collider(dummyWorld, 0, 0)
        rapier_create_cylinder_collider(dummyWorld, 0, 0, 0)
        rapier_create_cone_collider(dummyWorld, 0, 0, 0)
        rapier_create_capsule_collider(dummyWorld, 0, 0, 0)
        rapier_get_body_position_x(dummyWorld, 0)
        rapier_get_body_position_y(dummyWorld, 0)
        rapier_get_body_position_z(dummyWorld, 0)
        rapier_get_body_rotation_x(dummyWorld, 0)
        rapier_get_body_rotation_y(dummyWorld, 0)
        rapier_get_body_rotation_z(dummyWorld, 0)
        rapier_get_body_rotation_w(dummyWorld, 0)
        rapier_set_body_position(dummyWorld, 0, 0, 0, 0)
        rapier_set_body_rotation(dummyWorld, 0, 0, 0, 0, 0)
        rapier_create_fixed_joint(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_create_spherical_joint(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_create_revolute_joint(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_create_prismatic_joint(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_create_generic_joint(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_joint_lock_axis(dummyWorld, 0, 0, false)
        rapier_joint_set_limits(dummyWorld, 0, 0, 0, 0)
        rapier_joint_configure_motor(dummyWorld, 0, 0, 0, 0, 0, 0)
        rapier_joint_configure_revolute_motor(dummyWorld, 0, 0, 0, 0, 0)
        rapier_joint_configure_prismatic_motor(dummyWorld, 0, 0, 0, 0, 0)
        rapier_create_rope_joint(dummyWorld, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        rapier_create_heightfield_collider(dummyWorld, 0, nil, 0, 0, 0, 0, 0)
        rapier_wake_body(dummyWorld, 0)
        rapier_set_body_ccd(dummyWorld, 0, false)
        rapier_set_collider_friction(dummyWorld, 0, 0)
        rapier_set_collider_restitution(dummyWorld, 0, 0)
        rapier_set_collider_density(dummyWorld, 0, 0)
        rapier_set_body_linear_damping(dummyWorld, 0, 0)
        rapier_set_body_angular_damping(dummyWorld, 0, 0)
        rapier_body_add_force(dummyWorld, 0, 0, 0, 0)
        rapier_body_add_torque(dummyWorld, 0, 0, 0, 0)
        rapier_body_apply_impulse(dummyWorld, 0, 0, 0, 0)
        rapier_body_apply_torque_impulse(dummyWorld, 0, 0, 0, 0)
        rapier_body_add_force_at_point(dummyWorld, 0, 0, 0, 0, 0, 0, 0)
        rapier_body_apply_impulse_at_point(dummyWorld, 0, 0, 0, 0, 0, 0, 0)
        rapier_body_set_linear_velocity(dummyWorld, 0, 0, 0, 0)
        rapier_body_set_angular_velocity(dummyWorld, 0, 0, 0, 0)
        rapier_world_remove_rigid_body(dummyWorld, 0)
        rapier_world_remove_collider(dummyWorld, 0)
        rapier_world_remove_joint(dummyWorld, 0)
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
