import 'package:vector_math/vector_math.dart';
import 'collider.dart';
import 'rigid_body.dart';

/// Filter options for scene queries (e.g. raycasts, shape casts).
class QueryFilter {
  final Collider? excludeCollider;
  final RigidBody? excludeRigidBody;

  const QueryFilter({
    this.excludeCollider,
    this.excludeRigidBody,
  });

  static const QueryFilter none = QueryFilter();
}

/// Result of a raycast query.
class RayIntersection {
  final Collider collider;
  final RigidBody rigidBody;
  final double toi;
  final Vector3 point;
  final Vector3 normal;

  const RayIntersection({
    required this.collider,
    required this.rigidBody,
    required this.toi,
    required this.point,
    required this.normal,
  });

  @override
  String toString() =>
      'RayIntersection(collider: ${collider.handle}, rigidBody: ${rigidBody.handle}, toi: $toi, point: $point, normal: $normal)';
}

/// Result of a shape cast sweep query.
class ShapeIntersection {
  final Collider collider;
  final RigidBody rigidBody;
  final double toi;
  final Vector3 point;
  final Vector3 normal;

  const ShapeIntersection({
    required this.collider,
    required this.rigidBody,
    required this.toi,
    required this.point,
    required this.normal,
  });

  @override
  String toString() =>
      'ShapeIntersection(collider: ${collider.handle}, rigidBody: ${rigidBody.handle}, toi: $toi, point: $point, normal: $normal)';
}

/// Result of a point projection query.
class PointProjection {
  final Collider collider;
  final RigidBody rigidBody;
  final Vector3 point;
  final bool isInside;

  const PointProjection({
    required this.collider,
    required this.rigidBody,
    required this.point,
    required this.isInside,
  });

  @override
  String toString() =>
      'PointProjection(collider: ${collider.handle}, rigidBody: ${rigidBody.handle}, point: $point, isInside: $isInside)';
}
