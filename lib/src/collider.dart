import 'rapier_world.dart';
import 'rigid_body.dart';

class Collider {
  final int handle;
  final RigidBody body;

  Collider(this.handle, this.body);

  /// The local position of the collider relative to its parent rigid-body.
  Vector3 get position => RapierWorld.bindings.getColliderPosition(body.world.worldHandle, handle);
  void setPosition(Vector3 value) {
    RapierWorld.bindings.setColliderPosition(body.world.worldHandle, handle, value.x, value.y, value.z);
  }

  /// The local rotation of the collider relative to its parent rigid-body.
  Quaternion get rotation => RapierWorld.bindings.getColliderRotation(body.world.worldHandle, handle);
  void setRotation(Quaternion value) {
    RapierWorld.bindings.setColliderRotation(body.world.worldHandle, handle, value.x, value.y, value.z, value.w);
  }

  /// The density of the collider in kg/m³. Affects the body's mass if the body is dynamic.
  double get density => RapierWorld.bindings.getColliderDensity(body.world.worldHandle, handle);
  set density(double value) {
    RapierWorld.bindings.setColliderDensity(body.world.worldHandle, handle, value);
  }

  /// The friction coefficient of the collider. 0 = no friction, 1 = high friction.
  double get friction => RapierWorld.bindings.getColliderFriction(body.world.worldHandle, handle);
  set friction(double value) {
    RapierWorld.bindings.setColliderFriction(body.world.worldHandle, handle, value);
  }

  /// The restitution (bounciness) of the collider. 0 = no bounce, 1 = perfect bounce.
  double get restitution => RapierWorld.bindings.getColliderRestitution(body.world.worldHandle, handle);
  set restitution(double value) {
    RapierWorld.bindings.setColliderRestitution(body.world.worldHandle, handle, value);
  }
}

class BoxCollider extends Collider {
  final double hx, hy, hz;
  BoxCollider(super.handle, super.body, this.hx, this.hy, this.hz);
}

class SphereCollider extends Collider {
  final double radius;
  SphereCollider(super.handle, super.body, this.radius);
}

class CylinderCollider extends Collider {
  final double halfHeight, radius;
  CylinderCollider(super.handle, super.body, this.halfHeight, this.radius);
}

class ConeCollider extends Collider {
  final double halfHeight, radius;
  ConeCollider(super.handle, super.body, this.halfHeight, this.radius);
}

class CapsuleCollider extends Collider {
  final double halfHeight, radius;
  CapsuleCollider(super.handle, super.body, this.halfHeight, this.radius);
}

class HeightfieldCollider extends Collider {
  HeightfieldCollider(super.handle, super.body);
}
