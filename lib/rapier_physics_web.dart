// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'rapier_physics_platform_interface.dart';

/// A web implementation of the RapierPhysicsPlatform of the RapierPhysics plugin.
class RapierPhysicsWeb extends RapierPhysicsPlatform {
  /// Constructs a RapierPhysicsWeb
  RapierPhysicsWeb();

  static void registerWith(Registrar registrar) {
    RapierPhysicsPlatform.instance = RapierPhysicsWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
