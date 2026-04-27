import 'rapier_world.dart';

enum RigidBodyType { dynamic, fixed, kinematicPositionBased, kinematicVelocityBased }

class RigidBodyDesc {
  // world position (maps to Rapier translation)
  Vector3 position = Vector3.zero();
  Quaternion rotation = Quaternion.identity();

  Vector3 linearVelocity = Vector3.zero();
  Vector3 angularVelocity = Vector3.zero();

  double linearDamping = 0.0;
  double angularDamping = 0.0;

  RigidBodyType type;

  bool canSleep = true;
  bool ccdEnabled = false;

  RigidBodyDesc.dynamic() : type = RigidBodyType.dynamic;
  RigidBodyDesc.fixed() : type = RigidBodyType.fixed;
  RigidBodyDesc.kinematicPositionBased() : type = RigidBodyType.kinematicPositionBased;
  RigidBodyDesc.kinematicVelocityBased() : type = RigidBodyType.kinematicVelocityBased;
}
