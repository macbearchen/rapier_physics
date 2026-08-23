import 'rapier_physics_platform_interface.dart';

export 'src/character_controller.dart';
export 'src/collider.dart';
export 'src/collider_desc.dart';
export 'src/joint.dart';
export 'src/rapier_world.dart';
export 'src/rigid_body.dart';
export 'src/rigid_body_desc.dart';
export 'src/scene_query.dart';

class RapierPhysics {
  static const String version = "rapier_physics 0.5.1";

  Future<String?> getPlatformVersion() {
    return RapierPhysicsPlatform.instance.getPlatformVersion();
  }
}
