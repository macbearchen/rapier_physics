import 'package:flutter_test/flutter_test.dart';
import 'package:rapier_physics/rapier_physics.dart';

void main() {
  group('RapierWorld Scene Queries (QueryPipeline)', () {
    late RapierWorld world;

    setUp(() async {
      world = RapierWorld();
      await world.init();
    });

    tearDown(() {
      world.destroy();
    });

    test('castRay hits box and returns ray intersection details', () {
      // Add a box at position (0, 0, 5) with half extents (1, 1, 1).
      // Box extends from z = 4 to z = 6.
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      // Step physics world to build broad phase BVH
      world.step();

      final rayHit = world.castRay(
        Vector3(0, 0, 0),
        Vector3(0, 0, 1),
        maxToi: 10.0,
      );

      expect(rayHit, isNotNull);
      expect(rayHit!.rigidBody.handle, equals(boxBody.handle));
      expect(rayHit.toi, closeTo(4.0, 1e-3));
      expect(rayHit.point.z, closeTo(4.0, 1e-3));

      // Ray pointing in opposite direction should miss
      final rayMiss = world.castRay(
        Vector3(0, 0, 0),
        Vector3(0, 0, -1),
        maxToi: 10.0,
      );
      expect(rayMiss, isNull);
    });

    test('castRayAndGetNormal returns impact normal', () {
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      world.step();

      final rayHit = world.castRayAndGetNormal(
        Vector3(0, 0, 0),
        Vector3(0, 0, 1),
        maxToi: 10.0,
      );

      expect(rayHit, isNotNull);
      expect(rayHit!.rigidBody.handle, equals(boxBody.handle));
      expect(rayHit.toi, closeTo(4.0, 1e-3));
      // Normal should point back towards ray origin (-z direction)
      expect(rayHit.normal.z, closeTo(-1.0, 1e-3));
    });

    test('QueryFilter excludes specified body or collider', () {
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      world.step();

      final colliders = world.getBodyColliders(boxBody);
      expect(colliders, isNotEmpty);

      // Exclude rigid body
      final hitWithFilterBody = world.castRay(
        Vector3(0, 0, 0),
        Vector3(0, 0, 1),
        maxToi: 10.0,
        filter: QueryFilter(excludeRigidBody: boxBody),
      );
      expect(hitWithFilterBody, isNull);

      // Exclude collider
      final hitWithFilterCol = world.castRay(
        Vector3(0, 0, 0),
        Vector3(0, 0, 1),
        maxToi: 10.0,
        filter: QueryFilter(excludeCollider: colliders.first),
      );
      expect(hitWithFilterCol, isNull);
    });

    test('castShape sweeps shape against world colliders', () {
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      world.step();

      // Sweep a sphere of radius 0.5 from origin along +z axis towards box
      final shapeHit = world.castShape(
        Vector3(0, 0, 0),
        Quaternion.identity(),
        Vector3(0, 0, 1),
        ColliderDesc.ball(0.5),
        maxToi: 10.0,
      );

      expect(shapeHit, isNotNull);
      expect(shapeHit!.rigidBody.handle, equals(boxBody.handle));
      // Sphere touches box at z = 4.0, so toi = 4.0 - 0.5 = 3.5
      expect(shapeHit.toi, closeTo(3.5, 1e-3));
    });

    test('projectPoint finds closest point on colliders', () {
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      world.step();

      // Point at (0, 0, 3) is outside box [4, 6] along Z
      final proj = world.projectPoint(Vector3(0, 0, 3));

      expect(proj, isNotNull);
      expect(proj!.rigidBody.handle, equals(boxBody.handle));
      expect(proj.isInside, isFalse);
      expect(proj.point.z, closeTo(4.0, 1e-3));
    });

    test('intersectionsWithPoint finds colliders containing a point', () {
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      world.step();

      // Point at (0, 0, 5) is inside box
      final insideHits = world.intersectionsWithPoint(Vector3(0, 0, 5));
      expect(insideHits, isNotEmpty);
      expect(insideHits.first.body.handle, equals(boxBody.handle));

      // Point at (0, 0, 10) is outside
      final outsideHits = world.intersectionsWithPoint(Vector3(0, 0, 10));
      expect(outsideHits, isEmpty);
    });

    test('intersectionWithShape checks overlap of a shape in the scene', () {
      final boxBody = world.addBox(
        hx: 1.0,
        hy: 1.0,
        hz: 1.0,
        desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 5),
      );

      world.step();

      // Test overlap at (0, 0, 5) with a sphere
      final hitCol = world.intersectionWithShape(
        Vector3(0, 0, 5),
        Quaternion.identity(),
        ColliderDesc.ball(0.5),
      );
      expect(hitCol, isNotNull);
      expect(hitCol!.body.handle, equals(boxBody.handle));

      // Test no overlap far away at (0, 0, 20)
      final missCol = world.intersectionWithShape(
        Vector3(0, 0, 20),
        Quaternion.identity(),
        ColliderDesc.ball(0.5),
      );
      expect(missCol, isNull);
    });
  });
}
