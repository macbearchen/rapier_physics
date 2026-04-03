import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rapier_physics_platform_interface.dart';

/// An implementation of [RapierPhysicsPlatform] that uses method channels.
class MethodChannelRapierPhysics extends RapierPhysicsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rapier_physics');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
