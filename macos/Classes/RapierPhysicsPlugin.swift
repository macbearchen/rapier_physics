import Cocoa
import FlutterMacOS

@_silgen_name("rapier_world_create")
@discardableResult
func rapierWorldCreate() -> UnsafeMutableRawPointer?

public class RapierPhysicsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "rapier_physics", binaryMessenger: registrar.messenger)
    let instance = RapierPhysicsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    // Force symbols to be linked and not stripped by dummy call
    _ = rapierWorldCreate()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
