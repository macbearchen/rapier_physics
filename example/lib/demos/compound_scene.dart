import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'package:macbear_3d/macbear_3d.dart';
import 'package:rapier_physics/rapier_physics.dart';
import '../main_3d.dart';
import 'physics_scene.dart';

class CompoundScene extends BaseScene {
  final _random = Random();

  @override
  Future<void> load() async {
    await super.load();

    // Add a compound "Dumbbell" object
    const size = 3;
    for (int k = 0; k < 10; k++) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          final pos = Vector3((i - size / 2) * 3, (j - size / 2) * 3, 5 + k * 3);
          addDumbbell(pos);
        }
      }
    }
  }

  void addDumbbell(Vector3 pos) {
    // 1. Create a single dynamic rigid body
    final rb = world.createRigidBody(RigidBodyDesc.dynamic()..position = pos);

    // 2. Add multiple colliders with offsets

    // The handle (middle bar)
    world.createCollider(rb, ColliderDesc.cuboid(1.5, 0.1, 0.1));

    // Left weight
    world.createCollider(
      rb,
      ColliderDesc.ball(0.3)
        ..restitution = 0.9
        ..localPosition = Vector3(-1.5, 0, 0),
    );

    // Right weight
    world.createCollider(rb, ColliderDesc.ball(0.5)..localPosition = Vector3(1.5, 0, 0));

    // 3. Create a single visual mesh for the whole assembly
    final dumbbellMesh = M3Mesh(M3BoxGeom(3, 0.2, 0.2));

    // Add left weight as a submesh
    final leftSub = M3SubMesh(M3Resources.unitSphere);
    leftSub.localMatrix = Matrix4.compose(Vector3(-1.5, 0, 0), Quaternion.identity(), Vector3.all(0.6));
    leftSub.mtr.diffuse = Vector4(1.0, 1.0, 0.0, 1.0);
    dumbbellMesh.subMeshes.add(leftSub);

    // Add right weight as a submesh
    final rightSub = M3SubMesh(M3Resources.unitSphere);
    rightSub.localMatrix = Matrix4.compose(Vector3(1.5, 0, 0), Quaternion.identity(), Vector3.all(1.0));
    rightSub.mtr.diffuse = Vector4(0.0, 1.0, 1.0, 1.0);
    dumbbellMesh.subMeshes.add(rightSub);

    final dumbbellEntity = addMesh(dumbbellMesh, pos);
    mapEntityBody[rb] = dumbbellEntity;

    // Give it some initial rotation and angular velocity to see it tumble
    rb.setRotation(Quaternion(0.2, 0.3, 0.1, 1.0));
    rb.setAngularVelocity(
      Vector3(_random.nextDouble() * 6 - 3, _random.nextDouble() * 6 - 3, _random.nextDouble() * 6 - 3),
    );
  }
}
