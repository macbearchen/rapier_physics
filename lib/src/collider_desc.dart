import 'rapier_world.dart';

enum ColliderShapeType {
  cuboid,
  ball,
  cylinder,
  cone,
  capsule,
  heightfield,
}

class ColliderDesc {
  final ColliderShapeType shapeType;

  // Dimensions
  double hx = 0, hy = 0, hz = 0; // cuboid (half-extents)
  double radius = 0; // ball, cylinder, cone, capsule
  double halfHeight = 0; // cylinder, cone, capsule

  // Common properties
  Vector3 localPosition = Vector3.zero();
  Quaternion localRotation = Quaternion.identity();

  double friction = 0.5;
  double restitution = 0.0;
  double density = 1.0;

  ColliderDesc.cuboid(this.hx, this.hy, this.hz) : shapeType = ColliderShapeType.cuboid;
  ColliderDesc.ball(this.radius) : shapeType = ColliderShapeType.ball;
  ColliderDesc.cylinder(this.halfHeight, this.radius) : shapeType = ColliderShapeType.cylinder;
  ColliderDesc.cone(this.halfHeight, this.radius) : shapeType = ColliderShapeType.cone;
  ColliderDesc.capsule(this.halfHeight, this.radius) : shapeType = ColliderShapeType.capsule;
}
