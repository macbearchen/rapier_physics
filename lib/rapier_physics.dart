import 'rapier_physics_platform_interface.dart';

export 'src/collider.dart';
export 'src/collider_desc.dart';
export 'src/joint.dart';
export 'src/joint_axis.dart';
export 'src/rapier_world.dart';
export 'src/rigid_body.dart';
export 'src/rigid_body_desc.dart';

class RapierPhysics {
  Future<String?> getPlatformVersion() {
    return RapierPhysicsPlatform.instance.getPlatformVersion();
  }
}
