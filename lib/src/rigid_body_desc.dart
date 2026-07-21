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

  // --- Builder-style setters ---
  RigidBodyDesc setPosition(Vector3 position) {
    this.position.setFrom(position);
    return this;
  }

  RigidBodyDesc setRotation(Quaternion rotation) {
    this.rotation.setFrom(rotation);
    this.rotation.normalize();
    return this;
  }

  RigidBodyDesc setLinearVelocity(Vector3 velocity) {
    linearVelocity.setFrom(velocity);
    return this;
  }

  RigidBodyDesc setAngularVelocity(Vector3 velocity) {
    angularVelocity.setFrom(velocity);
    return this;
  }
}
