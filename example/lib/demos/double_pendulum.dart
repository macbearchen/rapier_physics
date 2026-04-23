import 'dart:math';
import 'package:vector_math/vector_math.dart';

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
// Rapier physics
import 'package:rapier_physics/rapier_physics.dart';
import '../main_3d.dart';
import 'physics_scene.dart';

class DoublePendulumScene extends SimpleScene {
  RigidBody? _rbS1;
  M3Entity? _entityS1;
  RigidBody? _rbS2;
  M3Entity? _entityS2;

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    addDoublePendulum(Vector3(0, 0, 9), 4);
  }

  void addDoublePendulum(Vector3 position, double length) {
    const double radius = 0.6;
    const double sphereDensity = 5.0; // Very heavy sphere

    // --- Sphere 1 ---
    final posSphere1 = position + Vector3(0, 0, -length);
    _entityS1 = addMesh(M3Mesh(M3Resources.unitSphere), posSphere1)..color = Colors.red;
    _rbS1 = world.addSphere(x: posSphere1.x, y: posSphere1.y, z: posSphere1.z, radius: radius);
    _rbS1!.colliders.first.density = sphereDensity;

    // Joint 1: Pin Sphere 1 to World at 'position'
    world.addRevoluteJointToWorld(
      _rbS1!,
      Vector3(0, 1, 0), // Axis Y
      Vector3(0, 0, length), // Local anchor relative to S1 center
      position, // World anchor
    );

    // --- Sphere 2 ---
    final posSphere2 = posSphere1 + Vector3(0, 0, -length);
    _entityS2 = addMesh(M3Mesh(M3Resources.unitSphere), posSphere2)..color = Colors.blue;
    _rbS2 = world.addSphere(x: posSphere2.x, y: posSphere2.y, z: posSphere2.z, radius: radius);
    _rbS2!.colliders.first.density = sphereDensity;

    // Joint 2: Connect Sphere 2 to Sphere 1
    world.addRevoluteJoint(
      _rbS1!,
      _rbS2!,
      Vector3(0, 1, 0), // Axis Y
      Vector3(0, 0, 0), // Local anchor 1: Center of S1
      Vector3(0, 0, length), // Local anchor 2: Up from S2 center
    );

    // Initial state: Tilt by 60 degrees
    const angle = pi / 3;
    const angle2 = pi / 1.2;
    final q = Quaternion.euler(-angle, 0, 0);
    final q2 = Quaternion.euler(-angle2, 0, 0);

    final pivot = position;
    final sphere1Center = pivot + Vector3(sin(angle) * length, 0, -cos(angle) * length);
    final sphere2Center = sphere1Center + Vector3(sin(angle2) * length, 0, -cos(angle2) * length);

    _rbS1!.setPosition(sphere1Center.x, sphere1Center.y, sphere1Center.z);
    _rbS1!.setRotation(q.x, q.y, q.z, q.w);

    _rbS2!.setPosition(sphere2Center.x, sphere2Center.y, sphere2Center.z);
    _rbS2!.setRotation(q2.x, q2.y, q2.z, q2.w);
  }

  @override
  void update(double delta) {
    world.step();

    if (_entityS1 != null && _rbS1 != null) {
      _entityS1!.position = _rbS1!.position;
      _entityS1!.rotation = _rbS1!.rotation;
    }

    if (_entityS2 != null && _rbS2 != null) {
      _entityS2!.position = _rbS2!.position;
      _entityS2!.rotation = _rbS2!.rotation;
    }

    super.update(delta);
  }
}
