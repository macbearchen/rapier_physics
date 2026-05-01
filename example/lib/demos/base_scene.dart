// ignore_for_file: unused_local_variable
import 'dart:math';
export 'dart:math';
import 'package:vector_math/vector_math.dart';
export 'package:vector_math/vector_math.dart';

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
export 'package:macbear_3d/macbear_3d.dart';

// Rapier physics
import 'package:rapier_physics/rapier_physics.dart';
export 'package:rapier_physics/rapier_physics.dart';

import '../main_3d.dart';

// Define a base scene
class BaseScene extends M3Scene {
  final Map<RigidBody, M3Entity> mapEntityBody = {};

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    M3AppEngine.backgroundColor = Vector3(0.04, 0.04, 0.8);

    camera.setEuler(pi / 9, -pi / 5, 0, distance: 20);
    light.setEuler(pi / 5, -pi / 3, 0, distance: 30);

    addGround();

    // sample cubemap
    skybox = M3Skybox(M3Texture.createSampleCubemap());
  }

  M3Mesh createPendulum(double radius, double length) {
    final pendulumMesh = M3Mesh(M3Resources.unitSphere);
    pendulumMesh.subMeshes[0].localMatrix.scaleByVector3(Vector3.all(radius / 0.5));

    final rodPart = M3SubMesh(M3Resources.unitCube);
    rodPart.localMatrix = Matrix4.compose(Vector3(0, 0, length / 2), Quaternion.identity(), Vector3(0.1, 0.1, length));
    pendulumMesh.subMeshes.add(rodPart);

    return pendulumMesh;
  }

  // ── Ground ──────────────────────────────────────────────────────────────────
  void addGround() {
    M3Texture texGrid = M3Texture.createCheckerboard(size: 10);
    M3Material mtr = M3Material();
    mtr.texDiffuse = texGrid;

    const hs = 10.0;
    // Fixed physics floor — top surface sits at z = 0
    world.addBox(hx: hs, hy: hs, hz: 0.5, desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, -0.5));

    final floor = addMesh(M3Mesh(M3PlaneGeom(hs * 2, hs * 2), material: mtr), Vector3(0, 0, 0));
    floor.color = Colors.limeGreen;
  }

  @override
  void update(double delta) {
    world.step();

    mapEntityBody.forEach((body, entity) {
      entity.position = body.position;
      entity.rotation = body.rotation;
    });

    super.update(delta);
  }
}
