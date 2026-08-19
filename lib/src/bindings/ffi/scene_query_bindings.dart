part of 'rapier_bindings_impl.dart';

// ==========================================
// Structs specific to scene queries
// (Shared: _ColliderDesc — declared in native_types.dart)
// ==========================================
final class _RayIntersectionC extends Struct {
  @Uint32()
  external int colliderHandle;
  @Uint32()
  external int rigidBodyHandle;
  @Float()
  external double toi;
  @Float()
  external double pointX;
  @Float()
  external double pointY;
  @Float()
  external double pointZ;
  @Float()
  external double normalX;
  @Float()
  external double normalY;
  @Float()
  external double normalZ;
  @Bool()
  external bool hit;
}

final class _ShapeCastHitC extends Struct {
  @Uint32()
  external int colliderHandle;
  @Uint32()
  external int rigidBodyHandle;
  @Float()
  external double toi;
  @Float()
  external double pointX;
  @Float()
  external double pointY;
  @Float()
  external double pointZ;
  @Float()
  external double normalX;
  @Float()
  external double normalY;
  @Float()
  external double normalZ;
  @Bool()
  external bool hit;
}

final class _PointProjectionC extends Struct {
  @Uint32()
  external int colliderHandle;
  @Uint32()
  external int rigidBodyHandle;
  @Float()
  external double pointX;
  @Float()
  external double pointY;
  @Float()
  external double pointZ;
  @Bool()
  external bool isInside;
  @Bool()
  external bool hit;
}

// ==========================================
// Native (C) Signatures
// ==========================================
typedef _CastRayC =
    _RayIntersectionC Function(Pointer<Void>, Float, Float, Float, Float, Float, Float, Float, Bool, Uint32, Uint32);
typedef _CastShapeC =
    _ShapeCastHitC Function(
      Pointer<Void>,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Pointer<_ColliderDesc>,
      Float,
      Bool,
      Uint32,
      Uint32,
    );
typedef _ProjectPointC = _PointProjectionC Function(Pointer<Void>, Float, Float, Float, Bool, Uint32, Uint32);
typedef _IntersectionsWithPointC =
    Size Function(Pointer<Void>, Float, Float, Float, Uint32, Uint32, Pointer<Uint32>, Size);
typedef _IntersectionWithShapeC =
    Uint32 Function(
      Pointer<Void>,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Float,
      Pointer<_ColliderDesc>,
      Uint32,
      Uint32,
    );

// ==========================================
// Dart Signatures
// ==========================================
typedef _CastRayDart =
    _RayIntersectionC Function(Pointer<Void>, double, double, double, double, double, double, double, bool, int, int);
typedef _CastShapeDart =
    _ShapeCastHitC Function(
      Pointer<Void>,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      Pointer<_ColliderDesc>,
      double,
      bool,
      int,
      int,
    );
typedef _ProjectPointDart = _PointProjectionC Function(Pointer<Void>, double, double, double, bool, int, int);
typedef _IntersectionsWithPointDart =
    int Function(Pointer<Void>, double, double, double, int, int, Pointer<Uint32>, int);
typedef _IntersectionWithShapeDart =
    int Function(
      Pointer<Void>,
      double,
      double,
      double,
      double,
      double,
      double,
      double,
      Pointer<_ColliderDesc>,
      int,
      int,
    );

/// FFI bindings for the `QueryPipeline`: ray casts, shape casts, point
/// projection, and point/shape intersection queries.
mixin SceneQueryBindings on FfiBindingsBase {
  late _CastRayDart _castRayNative;
  late _CastRayDart _castRayAndGetNormalNative;
  late _CastShapeDart _castShapeNative;
  late _ProjectPointDart _projectPointNative;
  late _IntersectionsWithPointDart _intersectionsWithPointNative;
  late _IntersectionWithShapeDart _intersectionWithShapeNative;

  void initSceneQueryBindings() {
    _castRayNative = dylib.lookupFunction<_CastRayC, _CastRayDart>('rapier_world_cast_ray');
    _castRayAndGetNormalNative =
        dylib.lookupFunction<_CastRayC, _CastRayDart>('rapier_world_cast_ray_and_get_normal');
    _castShapeNative = dylib.lookupFunction<_CastShapeC, _CastShapeDart>('rapier_world_cast_shape');
    _projectPointNative = dylib.lookupFunction<_ProjectPointC, _ProjectPointDart>('rapier_world_project_point');
    _intersectionsWithPointNative =
        dylib.lookupFunction<_IntersectionsWithPointC, _IntersectionsWithPointDart>(
      'rapier_world_intersections_with_point',
    );
    _intersectionWithShapeNative =
        dylib.lookupFunction<_IntersectionWithShapeC, _IntersectionWithShapeDart>(
      'rapier_world_intersection_with_shape',
    );
  }

  RayHitData? castRay(
    int world,
    double ox,
    double oy,
    double oz,
    double dx,
    double dy,
    double dz,
    double maxToi,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final res = _castRayNative(
      Pointer<Void>.fromAddress(world),
      ox,
      oy,
      oz,
      dx,
      dy,
      dz,
      maxToi,
      solid,
      excludeCollider,
      excludeRigidBody,
    );
    if (!res.hit) return null;
    return RayHitData(
      colliderHandle: res.colliderHandle,
      rigidBodyHandle: res.rigidBodyHandle,
      toi: res.toi,
      point: Vector3(res.pointX, res.pointY, res.pointZ),
      normal: Vector3(res.normalX, res.normalY, res.normalZ),
    );
  }

  RayHitData? castRayAndGetNormal(
    int world,
    double ox,
    double oy,
    double oz,
    double dx,
    double dy,
    double dz,
    double maxToi,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final res = _castRayAndGetNormalNative(
      Pointer<Void>.fromAddress(world),
      ox,
      oy,
      oz,
      dx,
      dy,
      dz,
      maxToi,
      solid,
      excludeCollider,
      excludeRigidBody,
    );
    if (!res.hit) return null;
    return RayHitData(
      colliderHandle: res.colliderHandle,
      rigidBodyHandle: res.rigidBodyHandle,
      toi: res.toi,
      point: Vector3(res.pointX, res.pointY, res.pointZ),
      normal: Vector3(res.normalX, res.normalY, res.normalZ),
    );
  }

  ShapeHitData? castShape(
    int world,
    double px,
    double py,
    double pz,
    double rx,
    double ry,
    double rz,
    double rw,
    double vx,
    double vy,
    double vz,
    ColliderDesc desc,
    double maxToi,
    bool stopAtPenetration,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final structPtr = calloc<_ColliderDesc>();
    try {
      structPtr.ref
        ..shapeType = desc.shapeType.index
        ..hx = desc.hx
        ..hy = desc.hy
        ..hz = desc.hz
        ..radius = desc.radius
        ..halfHeight = desc.halfHeight
        ..friction = desc.friction
        ..restitution = desc.restitution
        ..density = desc.density
        ..localPositionX = desc.localPosition.x
        ..localPositionY = desc.localPosition.y
        ..localPositionZ = desc.localPosition.z
        ..localRotationX = desc.localRotation.x
        ..localRotationY = desc.localRotation.y
        ..localRotationZ = desc.localRotation.z
        ..localRotationW = desc.localRotation.w
        ..isSensor = desc.isSensor;

      final res = _castShapeNative(
        Pointer<Void>.fromAddress(world),
        px,
        py,
        pz,
        rx,
        ry,
        rz,
        rw,
        vx,
        vy,
        vz,
        structPtr,
        maxToi,
        stopAtPenetration,
        excludeCollider,
        excludeRigidBody,
      );
      if (!res.hit) return null;
      return ShapeHitData(
        colliderHandle: res.colliderHandle,
        rigidBodyHandle: res.rigidBodyHandle,
        toi: res.toi,
        point: Vector3(res.pointX, res.pointY, res.pointZ),
        normal: Vector3(res.normalX, res.normalY, res.normalZ),
      );
    } finally {
      calloc.free(structPtr);
    }
  }

  PointProjectionData? projectPoint(
    int world,
    double px,
    double py,
    double pz,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final res = _projectPointNative(
      Pointer<Void>.fromAddress(world),
      px,
      py,
      pz,
      solid,
      excludeCollider,
      excludeRigidBody,
    );
    if (!res.hit) return null;
    return PointProjectionData(
      colliderHandle: res.colliderHandle,
      rigidBodyHandle: res.rigidBodyHandle,
      point: Vector3(res.pointX, res.pointY, res.pointZ),
      isInside: res.isInside,
    );
  }

  List<int> intersectionsWithPoint(
    int world,
    double px,
    double py,
    double pz,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    const maxCount = 128;
    final buffer = calloc<Uint32>(maxCount);
    try {
      final count = _intersectionsWithPointNative(
        Pointer<Void>.fromAddress(world),
        px,
        py,
        pz,
        excludeCollider,
        excludeRigidBody,
        buffer,
        maxCount,
      );
      final result = <int>[];
      for (var i = 0; i < count && i < maxCount; i++) {
        result.add(buffer[i]);
      }
      return result;
    } finally {
      calloc.free(buffer);
    }
  }

  int intersectionWithShape(
    int world,
    double px,
    double py,
    double pz,
    double rx,
    double ry,
    double rz,
    double rw,
    ColliderDesc desc,
    int excludeCollider,
    int excludeRigidBody,
  ) {
    final structPtr = calloc<_ColliderDesc>();
    try {
      structPtr.ref
        ..shapeType = desc.shapeType.index
        ..hx = desc.hx
        ..hy = desc.hy
        ..hz = desc.hz
        ..radius = desc.radius
        ..halfHeight = desc.halfHeight
        ..friction = desc.friction
        ..restitution = desc.restitution
        ..density = desc.density
        ..localPositionX = desc.localPosition.x
        ..localPositionY = desc.localPosition.y
        ..localPositionZ = desc.localPosition.z
        ..localRotationX = desc.localRotation.x
        ..localRotationY = desc.localRotation.y
        ..localRotationZ = desc.localRotation.z
        ..localRotationW = desc.localRotation.w
        ..isSensor = desc.isSensor;

      return _intersectionWithShapeNative(
        Pointer<Void>.fromAddress(world),
        px,
        py,
        pz,
        rx,
        ry,
        rz,
        rw,
        structPtr,
        excludeCollider,
        excludeRigidBody,
      );
    } finally {
      calloc.free(structPtr);
    }
  }
}
