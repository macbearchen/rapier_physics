// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
// Rapier physics
import 'package:rapier_physics/rapier_physics.dart';
import 'dart:math';

final world = RapierWorld();

// init rapier physics
Future<void> initPhysics() async {
  await world.init(gravity: Vector3(0, 0, -9.8));
  debugPrint('Rapier World Version: ${world.version}');
}

// Define a simple scene
class PhysicsScene extends M3Scene {
  final List<RigidBody> _rbBoxes = [];
  final List<RigidBody> _rbBalls = [];
  final List<RigidBody> _rbCylinders = [];
  RigidBody? _rbCapsule;

  final List<M3Entity> _boxes = [];
  final List<M3Entity> _balls = [];
  final List<M3Entity> _cylinders = [];
  M3Entity? _entityCapsule;

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    camera.setEuler(pi / 6, -pi / 6, 0, distance: 20);
    camera.csmCount = 0;

    // add geometry
    M3Entity ground = addMesh(M3Mesh(M3BoxGeom(10.0, 10.0, 2.0)), Vector3(0, 0, 0))..color = Colors.green;
    _entityCapsule = addMesh(M3Mesh(M3CapsuleGeom(0.5, 1.0)), Vector3(0, 0, 1.2))..color = Colors.yellow;

    final size = 6;
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        final ballPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 6);
        final boxPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 8);

        final box = addMesh(M3Mesh(M3Resources.unitCube), boxPos)..color = Colors.blue;
        final ball = addMesh(M3Mesh(M3Resources.unitSphere), ballPos)..color = Colors.red;
        _boxes.add(box);
        _balls.add(ball);

        box.physicsUpAxis = M3Axis.y;
        ball.physicsUpAxis = M3Axis.y;

        // physics part
        _rbBoxes.add(world.addBox(x: boxPos.x, y: boxPos.y, z: boxPos.z, hx: 0.5, hy: 0.5, hz: 0.5));
        _rbBalls.add(world.addSphere(x: ballPos.x, y: ballPos.y, z: ballPos.z, radius: 0.5));
      }
    }

    // vertical falling
    final random = Random();
    for (int i = 0; i < 200; i++) {
      final ballPos = Vector3(random.nextDouble() * 3 - 4, random.nextDouble() * 3 - 4, 10 + i * 2.2);
      final boxPos = Vector3(random.nextDouble() * 4, random.nextDouble() * 4, 10 + i * 1.5);
      final cylinderPos = Vector3(random.nextDouble() * 3 - 4, random.nextDouble() * 3 + 1, 10 + i * 2);

      final box = addMesh(M3Mesh(M3Resources.unitCube), boxPos)..color = Colors.yellow;
      final ball = addMesh(M3Mesh(M3Resources.unitSphere), ballPos)..color = Colors.skyBlue;
      final cylinder = addMesh(M3Mesh(M3CylinderGeom(0.5, 0.5, 1.0)), cylinderPos)..color = Colors.lightGreen;
      _boxes.add(box);
      _balls.add(ball);
      _cylinders.add(cylinder);

      box.physicsUpAxis = M3Axis.y;
      ball.physicsUpAxis = M3Axis.y;
      cylinder.physicsUpAxis = M3Axis.y;

      // physics part
      _rbBoxes.add(world.addBox(x: boxPos.x, y: boxPos.y, z: boxPos.z, hx: 0.5, hy: 0.5, hz: 0.5));
      _rbBalls.add(world.addSphere(x: ballPos.x, y: ballPos.y, z: ballPos.z, radius: 0.5));
      _rbCylinders.add(
        world.addCylinder(x: cylinderPos.x, y: cylinderPos.y, z: cylinderPos.z, halfHeight: 0.5, radius: 0.5),
      );
    }
    // addMesh(M3Mesh(M3PlaneGeom(10, 10)), Vector3(0, 0, -1)).color = Colors.skyBlue;

    _entityCapsule!.physicsUpAxis = M3Axis.y;

    // physics part
    // Create a static floor at y = 0
    world.addBox(x: 0, y: 0, z: 0, hx: 5.0, hy: 5, hz: 1, type: RigidBodyType.fixed);
    world.addBox(x: 0, y: -6, z: 8, hx: 5.0, hy: 1, hz: 8, type: RigidBodyType.fixed);
    world.addBox(x: 0, y: 6, z: 8, hx: 5.0, hy: 1, hz: 8, type: RigidBodyType.fixed);
    world.addBox(x: -6, y: 0, z: 8, hx: 1, hy: 5, hz: 8, type: RigidBodyType.fixed);
    world.addBox(x: 6, y: 0, z: 8, hx: 1, hy: 5, hz: 8, type: RigidBodyType.fixed);

    _rbCapsule = world.addCapsule(x: -1, y: -1, z: 3, halfHeight: 1.0, radius: 0.5);
  }

  static final Quaternion _qRotX90 = Quaternion.fromRotation(M3Constants.rotXPos90);
  static final Quaternion _qRotXNeg90 = Quaternion.fromRotation(M3Constants.rotXNeg90);

  @override
  void update(double delta) {
    world.step();
    // debugPrint('Box : ${_rbBox!.position}');
    // debugPrint('Ball: ${_rbBall!.position}');
    // debugPrint('Cylinder: ${_rbCylinder!.position}');
    // debugPrint('Capsule: ${_rbCapsule!.position}');

    for (int i = 0; i < _boxes.length; i++) {
      _boxes[i].position = _rbBoxes[i].position;
      _boxes[i].rotation = _rbBoxes[i].rotation;
      if (_boxes[i].physicsUpAxis == M3Axis.y) {
        _boxes[i].rotation = _boxes[i].rotation * _qRotXNeg90;
      }
    }
    for (int i = 0; i < _balls.length; i++) {
      _balls[i].position = _rbBalls[i].position;
      _balls[i].rotation = _rbBalls[i].rotation;
      if (_balls[i].physicsUpAxis == M3Axis.y) {
        _balls[i].rotation = _balls[i].rotation * _qRotXNeg90;
      }
    }
    for (int i = 0; i < _cylinders.length; i++) {
      _cylinders[i].position = _rbCylinders[i].position;
      _cylinders[i].rotation = _rbCylinders[i].rotation;
      if (_cylinders[i].physicsUpAxis == M3Axis.y) {
        _cylinders[i].rotation = _cylinders[i].rotation * _qRotXNeg90;
      }
    }
    _entityCapsule!.position = _rbCapsule!.position;

    _entityCapsule!.rotation = _rbCapsule!.rotation;
    if (_entityCapsule!.physicsUpAxis == M3Axis.y) {
      _entityCapsule!.rotation = _entityCapsule!.rotation * _qRotXNeg90;
    }

    super.update(delta);
  }
}
