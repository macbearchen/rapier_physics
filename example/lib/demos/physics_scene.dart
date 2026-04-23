// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart';

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
// Rapier physics
import 'package:rapier_physics/rapier_physics.dart';
import '../main_3d.dart';

// Define a simple scene
class SimpleScene extends M3Scene {
  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    M3AppEngine.backgroundColor = Vector3(0.04, 0.04, 0.8);

    camera.setEuler(pi / 8, -pi / 5, 0, distance: 18);
    light.setEuler(pi / 5, -pi / 3, 0, distance: 30);

    addGround();
    // axis gizmo
    //    addMesh(M3Resources.axisGizmoMesh, Vector3(0, 0, 2));
  }

  // ── Ground ──────────────────────────────────────────────────────────────────
  void addGround() {
    M3Texture texGrid = M3Texture.createCheckerboard(size: 10);
    M3Material mtr = M3Material();
    mtr.texDiffuse = texGrid;

    const hs = 10.0;
    // Fixed physics floor — top surface sits at z = 0
    world.addBox(x: 0, y: 0, z: -0.5, hx: hs, hy: hs, hz: 0.5, type: RigidBodyType.fixed);
    addMesh(M3Mesh(M3BoxGeom(hs * 2, hs * 2, 1.0), material: mtr), Vector3(0, 0, -0.5)).color = Colors.limeGreen;
  }
}

// Define a physics scene for testing
class PhysicsScene extends M3Scene {
  final List<RigidBody> _rbBoxes = [];
  final List<RigidBody> _rbBalls = [];
  final List<RigidBody> _rbCylinders = [];
  RigidBody? _rbCapsule;
  RigidBody? _rbCone;
  RigidBody? _rbFan;
  RigidBody? _rbLift;
  RigidBody? _rbCyl;
  RevoluteJoint? _fanJoint;
  PrismaticJoint? _liftJoint;
  GenericJoint? _cylJoint;

  final List<RigidBody> _rbRopes = [];
  final List<M3Entity> _ropes = [];

  final List<M3Entity> _boxes = [];
  final List<M3Entity> _balls = [];
  final List<M3Entity> _cylinders = [];
  M3Entity? _entityCapsule;
  M3Entity? _entityCone;
  M3Entity? _entityFan;
  M3Entity? _entityLift;
  M3Entity? _entityCyl;

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    M3AppEngine.backgroundColor = Vector3(0.1, 0.3, 0.15);

    camera.setEuler(pi / 6, -pi / 6, 0, distance: 30);
    light.setEuler(pi / 5, -pi / 3, 0, distance: 30); // rotate light

    // addMesh(M3Mesh(M3PlaneGeom(10, 10)), Vector3(0, 0, -1)).color = Colors.skyBlue;

    final capsuleGeom = M3CapsuleGeom(0.5, 1.0, axis: M3Axis.y);
    _entityCapsule = addMesh(M3Mesh(capsuleGeom), Vector3(0, 0, 1.2))..color = Colors.white;

    final coneGeom = M3CylinderGeom(0.0, 0.8, 2.0, axis: M3Axis.y);
    _entityCone = addMesh(M3Mesh(coneGeom), Vector3(0, 0, 1.2))..color = Colors.white;

    // physics part

    _rbCapsule = world.addCapsule(x: 2, y: -4, z: 3, halfHeight: 0.5, radius: 0.5);
    _rbCone = world.addCone(x: 4, y: -4, z: 3, halfHeight: 1, radius: 0.8);
    Quaternion q = Quaternion.euler(0, pi / 3, 0);
    // _rbCapsule?.setRotation(q.x, q.y, q.z, q.w);
    _rbCone?.setRotation(q.x, q.y, q.z, q.w);

    // Pin the capsule to a fixed point in world space
    world.addSphericalJointToWorld(
      _rbCapsule!,
      Vector3(0, 1, 0), // Local anchor on Capsule (top)
      Vector3(2, -4, 5), // Absolute world anchor
    );

    // Cylindrical Joint (GenericJoint)
    // Locked: X, Y, AngX, AngY. Free: Z, AngZ.
    _entityCyl = addMesh(M3Mesh(M3BoxGeom(1, 1, 1)), Vector3(-4, 4, 7))..color = Colors.lightGreen;
    _rbCyl = world.addBox(x: -4, y: 4, z: 7, hx: 0.5, hy: 0.5, hz: 0.5);
    _cylJoint = world.addGenericJoint(_rbCyl!, world.groundBody, Vector3.zero(), Vector3(-4, 4, 7));

    // Configure constraints
    world.lockJointAxis(_cylJoint!, JointAxis.x, true);
    world.lockJointAxis(_cylJoint!, JointAxis.y, true);
    world.lockJointAxis(_cylJoint!, JointAxis.angX, true);
    world.lockJointAxis(_cylJoint!, JointAxis.angY, true);

    // Set static motor for rotation, dynamic for translation
    world.configureJointMotor(_cylJoint!, JointAxis.angZ, targetVel: 5.0, damping: 0.5);

    // walls, falling, fan, lift, rope
    addWalls();
    addGridFall();
    // addFalling();
    addFan(Vector3(0, -10, -2));
    addLift(Vector3(-2, -10, -4));
    addRope(12, Vector3(9.5, 0, 0));

    addHeightfield();

    // axis gizmo
    addMesh(M3Resources.axisGizmoMesh, Vector3(0, 0, 0));
  }

  void addWalls() {
    // add geometry
    final hs = 6.0; // half size
    // addMesh(M3Mesh(M3BoxGeom(hs * 2, hs * 2, 2.0)), Vector3(0, 0, 0))..color = Colors.green;

    // Create a static floor at y = 0
    final halfWall = 30.0;
    // world.addBox(x: 0, y: 0, z: 0, hx: hs, hy: hs, hz: 1, type: RigidBodyType.fixed);
    // X
    world.addBox(x: -hs - 1, y: 0, z: 0, hx: 1, hy: halfWall, hz: halfWall, type: RigidBodyType.fixed);
    world.addBox(x: hs + 1, y: 0, z: 0, hx: 1, hy: halfWall, hz: halfWall, type: RigidBodyType.fixed);
    // Y
    world.addBox(x: 0, y: -hs - 1, z: 0, hx: halfWall, hy: 1, hz: halfWall, type: RigidBodyType.fixed);
    world.addBox(x: 0, y: hs + 1, z: 0, hx: halfWall, hy: 1, hz: halfWall, type: RigidBodyType.fixed);
    // Z
    // world.addBox(x: 0, y: 0, z: -hs - 1, hx: halfWall, hy: halfWall, hz: 1, type: RigidBodyType.fixed);
    // world.addBox(x: 0, y: 0, z: hs + 1, hx: halfWall, hy: halfWall, hz: 1, type: RigidBodyType.fixed);
  }

  void swapYZ(Vector3 v) {
    double temp = v.y;
    v.y = v.z;
    v.z = temp;
  }

  void addGridFall() {
    final size = 8;
    for (int k = 0; k < 18; k++) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          Vector3 ballPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 6 + k * 2);
          // swapYZ(ballPos);
          final ball = addMesh(M3Mesh(M3Resources.unitSphere), ballPos);

          if (i == 0) {
            ball.color = Colors.red;
          } else if (j == 0) {
            ball.color = Colors.blue;
          }

          _balls.add(ball);
          _rbBalls.add(world.addSphere(x: ballPos.x, y: ballPos.y, z: ballPos.z, radius: 0.5));

          /*
          final boxPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 8 + k * 4);
          final box = addMesh(M3Mesh(M3Resources.unitCube), boxPos)..color = Colors.blue;
          temp = boxPos.y;
          boxPos.y = boxPos.z;
          boxPos.z = temp;
          _boxes.add(box);
          _rbBoxes.add(world.addBox(x: boxPos.x, y: boxPos.y, z: boxPos.z, hx: 0.5, hy: 0.5, hz: 0.5));
          */
        }
      }
    }
  }

  void addFalling() {
    final cylGeom = M3CylinderGeom(0.5, 0.5, 1, axis: M3Axis.y);
    // vertical falling
    final random = Random();
    for (int i = 0; i < 350; i++) {
      final ballPos = Vector3(random.nextDouble() * 3 - 4, random.nextDouble() * 3 - 4, 10 + i * 2.2);
      final boxPos = Vector3(random.nextDouble() * 4, random.nextDouble() * 4, 10 + i * 1.5);
      final cylPos = Vector3(random.nextDouble() * 3 - 4, random.nextDouble() * 3 + 1, 10 + i * 2);

      // ball
      final ball = addMesh(M3Mesh(M3Resources.unitSphere), ballPos)..color = Colors.skyBlue;
      _balls.add(ball);
      _rbBalls.add(world.addSphere(x: ballPos.x, y: ballPos.y, z: ballPos.z, radius: 0.5));
      /*
      // box
      final box = addMesh(M3Mesh(M3Resources.unitCube), boxPos)..color = Colors.yellow;
      _boxes.add(box);
      _rbBoxes.add(world.addBox(x: boxPos.x, y: boxPos.y, z: boxPos.z, hx: 0.5, hy: 0.5, hz: 0.5));
     
      // cylinder
      final cylinder = addMesh(M3Mesh(cylGeom), cylPos)..color = Colors.lightGreen;
      _cylinders.add(cylinder);
      _rbCylinders.add(world.addCylinder(x: cylPos.x, y: cylPos.y, z: cylPos.z, halfHeight: 0.5, radius: 0.5));
  */
    }
  }

  void addFan(Vector3 pos) {
    // Motorized Fan (Revolute)
    _entityFan = addMesh(M3Mesh(M3BoxGeom(3, 0.6, 0.2)), pos)..color = Colors.orange;
    _rbFan = world.addBox(x: pos.x, y: pos.y, z: pos.z, hx: 1.5, hy: 0.3, hz: 0.1);
    _fanJoint = world.addRevoluteJointToWorld(_rbFan!, Vector3(0, 0, 1), Vector3.zero(), pos);
    world.configureRevoluteMotor(_fanJoint!, targetVel: 10.0, damping: 1.0);
    _rbFan!.wakeUp();
  }

  void addLift(Vector3 pos) {
    // Motorized Lift (Prismatic) — slides along X: (-2,-2,6) <-> (4,-2,6)
    // Anchor is fixed at the start position; targetPos is the offset along X (0=start, 6=end).
    _entityLift = addMesh(M3Mesh(M3BoxGeom(2, 2, 0.2)), pos)..color = Colors.purple;
    _rbLift = world.addBox(x: pos.x, y: pos.y, z: pos.z, hx: 1, hy: 1, hz: 0.1);
    _liftJoint = world.addPrismaticJointToWorld(_rbLift!, Vector3(1, 0, 0), Vector3.zero(), pos);
    world.configurePrismaticMotor(_liftJoint!, targetPos: 0.0, stiffness: 100.0, damping: 20.0);
    _rbLift!.wakeUp();
  }

  void addRope(int numSegments, Vector3 startPos) {
    // Rope Joint
    final hookPos = Vector3(-0.5, 0, 0);
    for (int i = 0; i < numSegments; i++) {
      final ropePos = Vector3(i.toDouble(), 0, 0) + startPos;
      // Use thin segments along X axis
      final rope = addMesh(M3Mesh(M3BoxGeom(1, 0.4, 0.4)), ropePos)..color = Colors.lightCoral;
      _ropes.add(rope);
      _rbRopes.add(world.addBox(x: ropePos.x, y: ropePos.y, z: ropePos.z, hx: 0.5, hy: 0.1, hz: 0.1));

      RopeJoint ropeJoint;
      if (i == 0) {
        // Anchor start of first segment to the wall
        ropeJoint = world.addRopeJoint(_rbRopes[i], world.groundBody, hookPos, ropePos + hookPos, 0.05);
      } else {
        // Connect start of current segment to end of previous segment
        ropeJoint = world.addRopeJoint(_rbRopes[i], _rbRopes[i - 1], hookPos, -hookPos, 0.05);
      }
      world.setJointLimits(ropeJoint, JointAxis.angX, -0.3, 0.3);
    }
  }

  void addHeightfield() {
    Vector3 pos = Vector3(0, 0, 0);
    Vector3 scale = Vector3(12, 1, 12);
    Float32List data = Float32List(4 * 3);
    // x = 0
    data[0] = 1;
    data[1] = 3;
    data[2] = 0;
    data[3] = 2;

    // x = 1
    data[4] = 0;
    data[5] = 0;
    data[6] = 0;
    data[7] = 0;

    // x = 2
    data[8] = 3;
    data[9] = 1;
    data[10] = 1;
    data[11] = 4;
    final rbHeightfield = world.addHeightfield(
      x: pos.x,
      y: pos.y,
      z: pos.z,
      heights: data,
      nrows: 4,
      ncols: 3,
      scale: scale,
    );
    final q = Quaternion.euler(0, pi / 2, 0); //pi / 2, 0);
    rbHeightfield.setRotation(q.x, q.y, q.z, q.w);

    // cornor dots
    final dot0 = addMesh(M3Mesh(M3Resources.debugDot), Vector3(-scale.x / 2, scale.z / 2, scale.y * 1))
      ..color = Colors.yellow;
    final dot1 = addMesh(M3Mesh(M3Resources.debugDot), Vector3(-scale.x / 2, -scale.z / 2, scale.y * 2))
      ..color = Colors.blue;
    final dot2 = addMesh(M3Mesh(M3Resources.debugDot), Vector3(scale.x / 2, scale.z / 2, scale.y * 3))
      ..color = Colors.red;
    final dot3 = addMesh(M3Mesh(M3Resources.debugDot), Vector3(scale.x / 2, -scale.z / 2, scale.y * 4))
      ..color = Colors.white;
    List<M3Entity> dots = [dot0, dot1, dot2, dot3];
  }

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
    }
    for (int i = 0; i < _balls.length; i++) {
      _balls[i].position = _rbBalls[i].position;
      _balls[i].rotation = _rbBalls[i].rotation;
    }
    for (int i = 0; i < _cylinders.length; i++) {
      _cylinders[i].position = _rbCylinders[i].position;
      _cylinders[i].rotation = _rbCylinders[i].rotation;
    }

    _entityCapsule!.position = _rbCapsule!.position;
    _entityCapsule!.rotation = _rbCapsule!.rotation;

    _entityCone!.position = _rbCone!.position;
    _entityCone!.rotation = _rbCone!.rotation;

    if (_entityFan != null && _rbFan != null) {
      _entityFan!.position = _rbFan!.position;
      _entityFan!.rotation = _rbFan!.rotation;
    }

    if (_entityLift != null && _rbLift != null) {
      _entityLift!.position = _rbLift!.position;
      _entityLift!.rotation = _rbLift!.rotation;

      // Oscillate along X: targetPos 0 = (-2,-2,6), targetPos 6 = (4,-2,6)
      final t = DateTime.now().millisecondsSinceEpoch / 1200.0;
      final targetX = (sin(t) + 1.0) / 2.0 * 6.0; // smooth 0..6
      world.configurePrismaticMotor(_liftJoint!, targetPos: targetX, stiffness: 100.0, damping: 20.0);
    }

    if (_entityCyl != null && _rbCyl != null) {
      _entityCyl!.position = _rbCyl!.position;
      _entityCyl!.rotation = _rbCyl!.rotation;

      // Dynamic cylindrical translation target
      double targetZ = sin(DateTime.now().millisecondsSinceEpoch / 1500.0) * 2.5;
      world.configureJointMotor(_cylJoint!, JointAxis.z, targetPos: targetZ, stiffness: 50.0, damping: 10.0);
    }

    for (int i = 0; i < _ropes.length; i++) {
      _ropes[i].position = _rbRopes[i].position;
      _ropes[i].rotation = _rbRopes[i].rotation;
    }

    super.update(delta);
  }
}
