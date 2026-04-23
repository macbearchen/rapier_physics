import 'dart:math';
import 'package:vector_math/vector_math.dart';

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
// Rapier physics
import 'package:rapier_physics/rapier_physics.dart';
import '../main_3d.dart';
import 'physics_scene.dart';

/// Newton's Cradle demo.
///
/// Coordinate system: gravity = (0, 0, -9.8)  →  Z is UP.
///   • Balls hang below the pivot rail along -Z.
///   • Swinging happens in the XZ plane.
///   • Hinge axis = Y  →  rotation around Y allows XZ-plane swing.
class NewtonCradleScene extends SimpleScene {
  final List<RigidBody> _rbBalls = [];
  final List<M3Entity> _balls = [];

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    _addNewtonCradle(count: 5, length: 4.0);
  }

  M3Mesh _createFrameMesh(double frameW, double yOff, double cradleZ) {
    // ── Visual-only frame (no physics body needed for a static frame) ─────────
    final halfW = frameW / 2.0;
    final frameMesh = M3Mesh(null);

    // Two horizontal rails at the top (front and back)
    final railGeom = M3BoxGeom(frameW, 0.12, 0.12);
    final subRail = M3SubMesh(railGeom);
    final subRail2 = M3SubMesh(railGeom);
    subRail.localMatrix.translateByVector3(Vector3(0, yOff, cradleZ));
    subRail2.localMatrix.translateByVector3(Vector3(0, -yOff, cradleZ));
    frameMesh.subMeshes.add(subRail);
    frameMesh.subMeshes.add(subRail2);

    // Four vertical corner legs
    final legGeom = M3BoxGeom(0.12, 0.12, cradleZ);
    final posArray = [
      Vector3(-halfW, -yOff, cradleZ / 2),
      Vector3(halfW, -yOff, cradleZ / 2),
      Vector3(-halfW, yOff, cradleZ / 2),
      Vector3(halfW, yOff, cradleZ / 2),
    ];
    for (final pos in posArray) {
      final subMesh = M3SubMesh(legGeom);
      subMesh.localMatrix.translateByVector3(pos);
      frameMesh.subMeshes.add(subMesh);
    }

    // Bottom crossbars connecting front / back legs at ground level
    final crossGeom = M3BoxGeom(0.12, yOff * 2, 0.12);
    final subCross = M3SubMesh(crossGeom);
    final subCross2 = M3SubMesh(crossGeom);
    subCross.localMatrix.translateByVector3(Vector3(-halfW, 0, 0.06));
    subCross2.localMatrix.translateByVector3(Vector3(halfW, 0, 0.06));
    frameMesh.subMeshes.add(subCross);
    frameMesh.subMeshes.add(subCross2);

    return frameMesh;
  }

  // ── Newton's Cradle ─────────────────────────────────────────────────────────
  void _addNewtonCradle({required int count, required double length}) {
    const spacing = 1.08; // tiny gap between balls
    final cradleZ = length + 1.0; // Z height of the top pivot rail
    final frameW = (count - 1) * spacing + 2.0; // rail length
    const yOff = 0.9; // front / back rail offset

    // ── Visual-only frame (no physics body needed for a static frame) ─────────
    final frameMesh = _createFrameMesh(frameW, yOff, cradleZ);
    addMesh(frameMesh, Vector3.zero());

    // ── Balls + hinge (revolute) joints ──────────────────────────────────────
    //
    // addRevoluteJointToWorld(body, worldAxis, localAnchor, worldAnchor)
    //
    //   worldAxis   = (0, 1, 0)         → rotate around Y → ball swings in XZ plane
    //   localAnchor = (0, 0, length)    → from ball centre UP to the pivot,
    //                                      in the ball's own local frame
    //   worldAnchor = (x, 0, cradleZ)  → the fixed pivot position in world space

    final ballMesh = M3Mesh(M3Resources.unitSphere);
    final restZ = cradleZ - length; // ball centre height when hanging at rest

    for (int i = 0; i < count; i++) {
      final x = (i - (count - 1) / 2.0) * spacing;
      final pos = Vector3(x, 0.0, restZ);

      final entity = addMesh(ballMesh, pos)..color = Colors.skyBlue;
      _balls.add(entity);

      final rb = world.addSphere(x: pos.x, y: pos.y, z: pos.z, radius: 0.5);
      for (final c in rb.colliders) {
        c.restitution = 1.0;
        c.friction = 0.0;
      }
      _rbBalls.add(rb);
      rb.setCCD(true);
      rb.wakeUp();

      // Every ball (including ball 0) must have a joint
      world.addRevoluteJointToWorld(
        rb,
        Vector3(0, 1, 0), // hinge axis = Y
        Vector3(0, 0, length), // local anchor: pivot is `length` above ball centre
        Vector3(x, 0, cradleZ), // world anchor: pivot position on the rail
      );
    }

    // Pull the leftmost ball back 60° to kick off the cradle motion.
    // Arc formula: newPos = pivot + length * (−sin θ along X,  −cos θ along Z)
    final pivotX = -(count - 1) / 2.0 * spacing;
    const pullAngle = pi / 3; // 60°
    _rbBalls[0].setPosition(
      pivotX - length * sin(pullAngle), // pulled back along −X
      0,
      cradleZ - length * cos(pullAngle), // raised along +Z
    );
  }

  // ── Update ──────────────────────────────────────────────────────────────────
  @override
  void update(double delta) {
    world.step();

    for (int i = 0; i < _balls.length; i++) {
      _balls[i].position = _rbBalls[i].position;
      _balls[i].rotation = _rbBalls[i].rotation;
    }
    super.update(delta);
  }
}
