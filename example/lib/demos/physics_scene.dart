// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart';

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
// Rapier physics
import 'package:rapier_physics/rapier_physics.dart';
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
    // axis gizmo
    addMesh(M3Resources.axisGizmoMesh, Vector3(0, 0, 1));

    final mesh = M3Mesh(M3Resources.unitSphere);
    addMesh(mesh, Vector3(5, 5, 2));

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

// Define a physics scene for testing
class PhysicsScene extends M3Scene {
  final Map<RigidBody, M3Entity> mapEntityBody = {};

  final ballMesh = M3Mesh(M3Resources.unitSphere);
  final boxMesh = M3Mesh(M3Resources.unitCube);
  final capsuleMesh = M3Mesh(M3CapsuleGeom(0.5, 1.0, axis: M3Axis.y));
  final coneMesh = M3Mesh(M3CylinderGeom(0.0, 0.8, 2.0, axis: M3Axis.y));

  PrismaticJoint? _liftJoint;

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    M3AppEngine.backgroundColor = Vector3(0.1, 0.3, 0.15);

    camera.setEuler(pi / 6, -pi / 6, 0, distance: 30);
    light.setEuler(pi / 5, -pi / 3, 0, distance: 30); // rotate light

    // addMesh(M3Mesh(M3PlaneGeom(10, 10)), Vector3(0, 0, -1)).color = Colors.skyBlue;

    final entityCapsule = addMesh(capsuleMesh, Vector3(0, 0, 1.2))..color = Colors.lime;
    final entityCone = addMesh(coneMesh, Vector3(0, 0, 1.2))..color = Colors.yellow;
    final rbCapsule = world.addCapsule(halfHeight: 0.5, radius: 0.5, desc: RigidBodyDesc.dynamic()..position = Vector3(2, -4, 3));
    final rbCone = world.addCone(halfHeight: 1, radius: 0.8, desc: RigidBodyDesc.dynamic()..position = Vector3(4, -4, 3));

    mapEntityBody[rbCapsule] = entityCapsule;
    mapEntityBody[rbCone] = entityCone;

    Quaternion q = Quaternion.euler(0, pi / 3, 0);
    // _rbCapsule?.setRotation(q.x, q.y, q.z, q.w);
    rbCone.setRotation(q);

    // Pin the capsule to a fixed point in world space
    world.addSphericalJointToWorld(
      rbCapsule,
      Vector3(0, 1, 0), // Local anchor on Capsule (top)
      Vector3(2, -4, 5), // Absolute world anchor
    );

    // Cylindrical Joint (GenericJoint)
    // Locked: X, Y, AngX, AngY. Free: Z, AngZ.
    final entityCyl = addMesh(M3Mesh(M3BoxGeom(1, 1, 1)), Vector3(-4, 4, 7))..color = Colors.lightGreen;
    final rbCyl = world.addBox(hx: 0.5, hy: 0.5, hz: 0.5, desc: RigidBodyDesc.dynamic()..position = Vector3(-4, 4, 7));
    mapEntityBody[rbCyl] = entityCyl;

    final cylJoint = world.addGenericJoint(rbCyl, world.groundBody, Vector3.zero(), Vector3(-4, 4, 7));

    // Configure constraints
    world.lockJointAxis(cylJoint, JointAxis.x, true);
    world.lockJointAxis(cylJoint, JointAxis.y, true);
    world.lockJointAxis(cylJoint, JointAxis.angX, true);
    world.lockJointAxis(cylJoint, JointAxis.angY, true);

    // Set static motor for rotation, dynamic for translation
    world.configureJointMotor(cylJoint, JointAxis.angZ, targetVel: 5.0, damping: 0.5);

    // walls, falling, fan, lift, rope
    addWalls();
    addGridFall();
    // addFalling();
    addFan(Vector3(0, -10, -2));
    addLift(Vector3(-2, -10, -4));
    addRope(12, Vector3(10, 0, 4));

    addHeightfield();

    // axis gizmo
    // addMesh(M3Resources.axisGizmoMesh, Vector3(0, 0, 0));
  }

  void addWalls() {
    // add geometry
    final hs = 6.0; // half size
    // addMesh(M3Mesh(M3BoxGeom(hs * 2, hs * 2, 2.0)), Vector3(0, 0, 0))..color = Colors.green;

    // Create a static floor at y = 0
    final halfWall = 30.0;
    // world.addBox(x: 0, y: 0, z: 0, hx: hs, hy: hs, hz: 1, type: RigidBodyType.fixed);
    // X
    world.addBox(hx: 1, hy: halfWall, hz: halfWall, desc: RigidBodyDesc.fixed()..position = Vector3(-hs - 1, 0, 0));
    world.addBox(hx: 1, hy: halfWall, hz: halfWall, desc: RigidBodyDesc.fixed()..position = Vector3(hs + 1, 0, 0));
    // Y
    world.addBox(hx: halfWall, hy: 1, hz: halfWall, desc: RigidBodyDesc.fixed()..position = Vector3(0, -hs - 1, 0));
    world.addBox(hx: halfWall, hy: 1, hz: halfWall, desc: RigidBodyDesc.fixed()..position = Vector3(0, hs + 1, 0));
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
    final size = 6;
    for (int k = 0; k < 18; k++) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          Vector3 ballPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 6 + k * 3);
          // swapYZ(ballPos);
          final ball = addMesh(ballMesh, ballPos);
          final rbBall = world.addSphere(radius: 0.5, desc: RigidBodyDesc.dynamic()..position = ballPos);
          mapEntityBody[rbBall] = ball;

          if (i == 0) {
            ball.color = Colors.red;
          } else if (j == 0) {
            ball.color = Colors.blue;
          }

          final boxPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 7.5 + k * 3);
          final box = addMesh(boxMesh, boxPos)..color = Colors.blue;
          final rbBox = world.addBox(hx: 0.5, hy: 0.5, hz: 0.5, desc: RigidBodyDesc.dynamic()..position = boxPos);
          mapEntityBody[rbBox] = box;
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
      final ball = addMesh(ballMesh, ballPos)..color = Colors.skyBlue;
      final rbBall = world.addSphere(radius: 0.5, desc: RigidBodyDesc.dynamic()..position = ballPos);
      mapEntityBody[rbBall] = ball;
      /*
      // box
      final box = addMesh(M3Mesh(M3Resources.unitCube), boxPos)..color = Colors.yellow;
      _boxes.add(box);
      _rbBoxes.add(world.addBox(hx: 0.5, hy: 0.5, hz: 0.5, desc: RigidBodyDesc.dynamic()..position = boxPos));
     
      // cylinder
      final cylinder = addMesh(M3Mesh(cylGeom), cylPos)..color = Colors.lightGreen;
      _cylinders.add(cylinder);
      _rbCylinders.add(world.addCylinder(halfHeight: 0.5, radius: 0.5, desc: RigidBodyDesc.dynamic()..position = cylPos));
  */
    }
  }

  void addFan(Vector3 pos) {
    // Motorized Fan (Revolute)
    final entityFan = addMesh(M3Mesh(M3BoxGeom(3, 0.6, 0.2)), pos)..color = Colors.orange;
    final rbFan = world.addBox(hx: 1.5, hy: 0.3, hz: 0.1, desc: RigidBodyDesc.dynamic()..position = pos);
    mapEntityBody[rbFan] = entityFan;

    final fanJoint = world.addRevoluteJointToWorld(rbFan, Vector3(0, 0, 1), Vector3.zero(), pos);
    world.configureRevoluteMotor(fanJoint, targetVel: 10.0, damping: 1.0);
    rbFan.wakeUp();
  }

  void addLift(Vector3 pos) {
    // Motorized Lift (Prismatic) — slides along X: (-2,-2,6) <-> (4,-2,6)
    // Anchor is fixed at the start position; targetPos is the offset along X (0=start, 6=end).
    final entityLift = addMesh(M3Mesh(M3BoxGeom(2, 2, 0.2)), pos)..color = Colors.purple;
    final rbLift = world.addBox(hx: 1, hy: 1, hz: 0.1, desc: RigidBodyDesc.dynamic()..position = pos);
    mapEntityBody[rbLift] = entityLift;

    final liftJoint = world.addPrismaticJointToWorld(rbLift, Vector3(1, 0, 0), Vector3.zero(), pos);
    world.configurePrismaticMotor(liftJoint, targetPos: 0.0, stiffness: 100.0, damping: 20.0);
    _liftJoint = liftJoint;
    rbLift.wakeUp();
  }

  void addRope(int numSegments, Vector3 startPos) {
    final List<RigidBody> rbRopes = [];
    final ropeMesh = M3Mesh(M3BoxGeom(1, 0.4, 0.4));
    // Rope Joint
    final hookPos = Vector3(-0.5, 0, 0);
    for (int i = 0; i < numSegments; i++) {
      final ropePos = Vector3(i.toDouble(), 0, 0) + startPos;
      // Use thin segments along X axis
      final rope = addMesh(ropeMesh, ropePos)..color = Colors.lightCoral;
      final rbRope = world.addBox(hx: 0.5, hy: 0.1, hz: 0.1, desc: RigidBodyDesc.dynamic()..position = ropePos);
      rbRopes.add(rbRope);
      mapEntityBody[rbRope] = rope;

      RopeJoint ropeJoint;
      if (i == 0) {
        // Anchor start of first segment to the wall
        ropeJoint = world.addRopeJoint(rbRopes[i], world.groundBody, hookPos, ropePos + hookPos, 0.05);
      } else {
        // Connect start of current segment to end of previous segment
        ropeJoint = world.addRopeJoint(rbRopes[i], rbRopes[i - 1], hookPos, -hookPos, 0.05);
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
      heights: data,
      nrows: 4,
      ncols: 3,
      scale: scale,
      desc: RigidBodyDesc.fixed()..position = pos,
    );
    final q = Quaternion.euler(0, pi / 2, 0); //pi / 2, 0);
    rbHeightfield.setRotation(q);

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

    // Oscillate along X: targetPos 0 = (-2,-2,6), targetPos 6 = (4,-2,6)
    final t = DateTime.now().millisecondsSinceEpoch / 1200.0;
    final targetX = (sin(t) + 1.0) / 2.0 * 6.0; // smooth 0..6
    world.configurePrismaticMotor(_liftJoint!, targetPos: targetX, stiffness: 100.0, damping: 20.0);

    // Sync all physics bodies to render entities
    mapEntityBody.forEach((body, entity) {
      entity.position = body.position;
      entity.rotation = body.rotation;
    });

    super.update(delta);
  }
}
