import 'rigid_body.dart';

class Collider {
  final int handle;
  final RigidBody body;

  Collider(this.handle, this.body);

  double _density = 1.0;
  double _friction = 0.5;
  double _restitution = 0.0;

  /// The density of the collider in kg/m³. Affects the body's mass if the body is dynamic.
  double get density => _density;
  set density(double value) {
    _density = value;
    body.world.bindings.setColliderDensity(body.world.worldHandle, handle, value);
  }

  /// The friction coefficient of the collider. 0 = no friction, 1 = high friction.
  double get friction => _friction;
  set friction(double value) {
    _friction = value;
    body.world.bindings.setColliderFriction(body.world.worldHandle, handle, value);
  }

  /// The restitution (bounciness) of the collider. 0 = no bounce, 1 = perfect bounce.
  double get restitution => _restitution;
  set restitution(double value) {
    _restitution = value;
    body.world.bindings.setColliderRestitution(body.world.worldHandle, handle, value);
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
