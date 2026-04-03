import 'rapier_physics_platform_interface.dart';

export 'src/rapier_world.dart';
export 'src/rigid_body.dart';
export 'src/collider.dart';
export 'src/rigid_body_type.dart';

class RapierPhysics {
  Future<String?> getPlatformVersion() {
    return RapierPhysicsPlatform.instance.getPlatformVersion();
  }
}
