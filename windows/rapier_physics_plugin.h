#ifndef FLUTTER_PLUGIN_RAPIER_PHYSICS_PLUGIN_H_
#define FLUTTER_PLUGIN_RAPIER_PHYSICS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace rapier_physics {

class RapierPhysicsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RapierPhysicsPlugin();

  virtual ~RapierPhysicsPlugin();

  // Disallow copy and assign.
  RapierPhysicsPlugin(const RapierPhysicsPlugin&) = delete;
  RapierPhysicsPlugin& operator=(const RapierPhysicsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace rapier_physics

#endif  // FLUTTER_PLUGIN_RAPIER_PHYSICS_PLUGIN_H_
