import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rapier_physics_method_channel.dart';

abstract class RapierPhysicsPlatform extends PlatformInterface {
  /// Constructs a RapierPhysicsPlatform.
  RapierPhysicsPlatform() : super(token: _token);

  static final Object _token = Object();

  static RapierPhysicsPlatform _instance = MethodChannelRapierPhysics();

  /// The default instance of [RapierPhysicsPlatform] to use.
  ///
  /// Defaults to [MethodChannelRapierPhysics].
  static RapierPhysicsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RapierPhysicsPlatform] when
  /// they register themselves.
  static set instance(RapierPhysicsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
