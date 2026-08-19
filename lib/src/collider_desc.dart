import 'rapier_world.dart';

// dart format off
enum ColliderShapeType {
  cuboid,
  ball,
  cylinder,
  cone,
  capsuleX,
  capsuleY,
  capsuleZ,
  heightfield,
}
// dart format on

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
  bool isSensor = false;

  ColliderDesc.cuboid(this.hx, this.hy, this.hz) : shapeType = ColliderShapeType.cuboid;
  ColliderDesc.ball(this.radius) : shapeType = ColliderShapeType.ball;
  ColliderDesc.cylinder({required this.radius, required this.halfHeight}) : shapeType = ColliderShapeType.cylinder;
  ColliderDesc.cone({required this.radius, required this.halfHeight}) : shapeType = ColliderShapeType.cone;
  ColliderDesc.capsuleX({required this.radius, required this.halfHeight}) : shapeType = ColliderShapeType.capsuleX;
  ColliderDesc.capsuleY({required this.radius, required this.halfHeight}) : shapeType = ColliderShapeType.capsuleY;
  ColliderDesc.capsuleZ({required this.radius, required this.halfHeight}) : shapeType = ColliderShapeType.capsuleZ;
}
