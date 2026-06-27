#include "include/rapier_physics/rapier_physics_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "rapier_physics_plugin.h"

void RapierPhysicsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  rapier_physics::RapierPhysicsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
