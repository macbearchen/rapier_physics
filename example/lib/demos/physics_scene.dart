// ignore_for_file: unused_local_variable
import 'base_scene.dart';

// Define a physics scene for testing
class PhysicsScene extends BaseScene {
  final ballMesh = M3Mesh(M3Resources.unitSphere);
  final boxMesh = M3Mesh(M3Resources.unitCube);
  final capsuleMesh = M3Mesh(M3CapsuleGeom(0.5, 1.0, axis: M3Axis.y));
  final coneMesh = M3Mesh(M3CylinderGeom(0.0, 0.8, 2.0, axis: M3Axis.y));

  PrismaticJoint? _liftJoint;

  // constructor
  PhysicsScene({required super.physics});

  @override
  Future<void> load() async {
    if (isLoaded) return;
    await super.load();

    M3AppEngine.backgroundColor = Vector3(0.1, 0.3, 0.15);

    camera.setEuler(pi / 6, -pi / 6, 0, distance: 30);
    light.setEuler(pi / 5, -pi / 3, 0, distance: 30); // rotate light

    // addMesh(M3Mesh(M3PlaneGeom(10, 10)), Vector3(0, 0, -1)).color = Colors.skyBlue;

    final entityCapsule = addMesh(capsuleMesh, Vector3(0, 0, 1.2))..color = Colors.lime;
    final rbCapsule = physicsSystem.addCapsule(0.5, 0.5, M3RigidBodyDesc.dynamic()..position = Vector3(2, -4, 3));
    physicsSystem.attachEntity(entityCapsule, rbCapsule);

    if (rbCapsule is M3RapierRigidBody) {
      // Pin the capsule to a fixed point in world space
      world.addSphericalJointToWorld(
        rbCapsule,
        Vector3(0, 1, 0), // Local anchor on Capsule (top)
        Vector3(2, -4, 5), // Absolute world anchor
      );
    }

    // Cylindrical Joint (GenericJoint)
    // Locked: X, Y, AngX, AngY. Free: Z, AngZ.
    final box = addMesh(M3Mesh(M3BoxGeom(1, 1, 1)), Vector3(-4, 4, 7))..color = Colors.lightGreen;
    final rbBox = physicsSystem.addBox(0.5, 0.5, 0.5, M3RigidBodyDesc.dynamic()..position = Vector3(-4, 4, 7));
    physicsSystem.attachEntity(box, rbBox);

    if (rbBox is M3RapierRigidBody) {
      final cylJoint = world.addGenericJoint(rbBox, world.groundBody, Vector3.zero(), Vector3(-4, 4, 7));
      // Configure constraints
      world.lockJointAxis(cylJoint, JointAxis.x, true);
      world.lockJointAxis(cylJoint, JointAxis.y, true);
      world.lockJointAxis(cylJoint, JointAxis.angX, true);
      world.lockJointAxis(cylJoint, JointAxis.angY, true);

      // Set static motor for rotation, dynamic for translation
      world.configureJointMotor(cylJoint, JointAxis.angZ, targetVel: 5.0, damping: 0.5);
    }

    // walls, falling, fan, lift, rope
    addWalls();
    addGridFall();
    // addFalling();
    addFan(Vector3(0, -12, 4));
    addLift(Vector3(5, -12, 8));
    addRope(12, Vector3(12, 0, 8));

    addHeightGeom();

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
    final size = 8;
    for (int k = 0; k < 28; k++) {
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          Vector3 ballPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 6 + k * 3);
          // swapYZ(ballPos);
          final ball = addMesh(ballMesh, ballPos);
          final rbBall = physicsSystem.addSphere(0.5, M3RigidBodyDesc.dynamic()..position = ballPos);
          physicsSystem.attachEntity(ball, rbBall);

          if (i == 0) {
            ball.color = Colors.red;
          } else if (j == 0) {
            ball.color = Colors.blue;
          }
          /*
          final boxPos = Vector3((i - size / 2) * 1.2, (j - size / 2) * 1.2, 7.5 + k * 3);
          final box = addMesh(boxMesh, boxPos)..color = Colors.blue;
          final rbBox = physicsSystem.addBox(0.5, 0.5, 0.5, M3RigidBodyDesc.dynamic()..position = boxPos);
          physicsSystem.attachEntity(box, rbBox);
          */
        }
      }
    }
  }

  void addFalling() {
    final cylGeom = M3CylinderGeom(0.5, 0.5, 1, axis: M3Axis.y);
    // vertical falling
    final random = Random();
    for (int i = 0; i < 30; i++) {
      final ballPos = Vector3(random.nextDouble() * 3 - 4, random.nextDouble() * 3 - 4, 10 + i * 2.2);
      final boxPos = Vector3(random.nextDouble() * 4, random.nextDouble() * 4, 10 + i * 1.5);
      final cylPos = Vector3(random.nextDouble() * 3 - 4, random.nextDouble() * 3 + 1, 10 + i * 2);

      // ball
      final ball = addMesh(ballMesh, ballPos)..color = Colors.skyBlue;
      final rbBall = physicsSystem.addSphere(0.5, M3RigidBodyDesc.dynamic()..position = ballPos);
      physicsSystem.attachEntity(ball, rbBall);

      // box
      final box = addMesh(M3Mesh(M3Resources.unitCube), boxPos)..color = Colors.yellow;
      final rbBox = physicsSystem.addBox(0.5, 0.5, 0.5, M3RigidBodyDesc.dynamic()..position = boxPos);
      physicsSystem.attachEntity(box, rbBox);

      // cylinder
      final cylinder = addMesh(M3Mesh(cylGeom), cylPos)..color = Colors.lightGreen;
      final rbCyl = physicsSystem.addCylinder(0.5, 0.5, M3RigidBodyDesc.dynamic()..position = cylPos);
      physicsSystem.attachEntity(cylinder, rbCyl);
    }
  }

  void addFan(Vector3 pos) {
    // Motorized Fan (Revolute)
    final entityFan = addMesh(M3Mesh(M3BoxGeom(3, 0.6, 0.2)), pos)..color = Colors.orange;
    final rbFan = physicsSystem.addBox(1.5, 0.3, 0.1, M3RigidBodyDesc.dynamic()..position = pos);
    physicsSystem.attachEntity(entityFan, rbFan);

    // Get world body and joint to it
    if (rbFan is M3RapierRigidBody) {
      final fanJoint = world.addRevoluteJointToWorld(rbFan, Vector3(0, 0, 1), Vector3.zero(), pos);
      world.configureRevoluteMotor(fanJoint, targetVel: 10.0, damping: 1.0);
      rbFan.wakeUp();
    }
  }

  void addLift(Vector3 pos) {
    // Motorized Lift (Prismatic) — slides along X: (-2,-2,6) <-> (4,-2,6)
    // Anchor is fixed at the start position; targetPos is the offset along X (0=start, 6=end).
    final entityLift = addMesh(M3Mesh(M3BoxGeom(2, 2, 0.2)), pos)..color = Colors.purple;
    final rbLift = physicsSystem.addBox(1, 1, 0.1, M3RigidBodyDesc.dynamic()..position = pos);
    physicsSystem.attachEntity(entityLift, rbLift);

    if (rbLift is M3RapierRigidBody) {
      final liftJoint = world.addPrismaticJointToWorld(rbLift, Vector3(1, 0, 0), Vector3.zero(), pos);
      world.configurePrismaticMotor(liftJoint, targetPos: 0.0, stiffness: 100.0, damping: 20.0);
      _liftJoint = liftJoint;
      rbLift.wakeUp();
    }
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
      final rbRope = physicsSystem.addBox(0.5, 0.1, 0.1, M3RigidBodyDesc.dynamic()..position = ropePos);
      physicsSystem.attachEntity(rope, rbRope);

      if (rbRope is M3RapierRigidBody) {
        rbRopes.add(rbRope);
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
  }

  double onWave(double x, double y) {
    double rad = pi / 3;
    if (y >= 5 && (x <= -5 || x >= 5)) {
      return 7;
    }
    return (cos(x * rad) + sin(y * rad));
  }

  void addHeightGeom() {
    // 04-2: plane geometry
    final geomPlane = M3PlaneGeom(
      12,
      12,
      widthSegments: 3,
      heightSegments: 3,
      uvScale: Vector2.all(5.0),
      shading: M3ShadingMode.flat,
      onVertex: onWave,
    );

    geomPlane.funcVertex = onWave;
    final hf = geomPlane.toHeightField();
    final hfData = hf.data;
    final plane = addMesh(M3Mesh(geomPlane), Vector3(0, 0, 2));

    Vector3 scale = Vector3(12, 1, 12);
    Vector3 pos = Vector3(0, 0, 2);

    final rbHeightfield = world.addHeightfield(
      heights: hfData,
      nrows: geomPlane.widthSegments + 1,
      ncols: geomPlane.heightSegments + 1,
      scale: scale,
      desc: RigidBodyDesc.fixed()..position = pos,
    );
    final q = Quaternion.euler(0, pi / 2, 0); //pi / 2, 0);
    rbHeightfield.setRotation(q);
  }

  @override
  void update(double delta) {
    // Oscillate along X: targetPos 0 = (-2,-2,6), targetPos 6 = (4,-2,6)
    final t = DateTime.now().millisecondsSinceEpoch / 1200.0;
    final targetX = (sin(t) + 1.0) / 2.0 * 6.0; // smooth 0..6
    world.configurePrismaticMotor(_liftJoint!, targetPos: targetX, stiffness: 100.0, damping: 20.0);

    super.update(delta);
  }
}
