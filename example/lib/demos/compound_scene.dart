import 'base_scene.dart';

class CompoundScene extends BaseScene {
  final _random = Random();

  // ── Dumbbell spawner ────────────────────────────────────────────────────────
  static final Vector3 _spawnOrigin = Vector3(0, 0, 10);
  static const int _maxSpawned = 500;
  static const double _spawnInterval = 0.1; // 10 dumbbells/sec
  int _spawnedCount = 0;
  double _spawnAccum = 0.0;

  CompoundScene({required super.physics});

  @override
  Future<void> load() async {
    await super.load();

    // Add a compound "Dumbbell" object
    addDumbbell(Vector3(0, 0, 5));

    // Dynamic green sphere at (-3, -2, 5.0) — radius 0.8 for both physics & mesh
    final pos2 = Vector3(-3, -2, 5.0);
    final rb = physicsSystem.addSphere(0.8, desc: M3RigidBodyDesc.dynamic()..position = pos2);
    final entity = addMesh(M3Mesh(M3SphereGeom(0.8)), pos2)..color = Colors.lime;
    physicsSystem.attachEntity(entity, rb);
  }

  void addDumbbell(Vector3 pos) {
    // 1. Create a single dynamic rigid body, The handle (middle bar)
    final rb = physicsSystem.addBox(1, 0.1, 0.1, desc: M3RigidBodyDesc.dynamic()..position = pos);

    // 2. Add multiple colliders with offsets
    if (rb is M3RapierRigidBody) {
      // Left weight
      world.createCollider(
        rb,
        ColliderDesc.ball(0.3)
          ..restitution = 0.9
          ..localPosition = Vector3(-1, 0, 0),
      );

      // Right weight
      world.createCollider(rb, ColliderDesc.ball(0.6)..localPosition = Vector3(1, 0, 0));

      // 3. Create a single visual mesh for the whole assembly
      final dumbbellMesh = M3Mesh(M3BoxGeom(2, 0.2, 0.2));

      // Add left weight as a submesh
      final leftSub = M3SubMesh(M3Resources.unitSphere);
      leftSub.localMatrix = Matrix4.compose(Vector3(-1, 0, 0), Quaternion.identity(), Vector3.all(0.6));
      leftSub.mtr.diffuse = Vector4(1.0, 1.0, 0.0, 1.0);
      dumbbellMesh.subMeshes.add(leftSub);

      // Add right weight as a submesh
      final rightSub = M3SubMesh(M3Resources.unitSphere);
      rightSub.localMatrix = Matrix4.compose(Vector3(1, 0, 0), Quaternion.identity(), Vector3.all(1.2));
      rightSub.mtr.diffuse = Vector4(0.0, 1.0, 1.0, 1.0);
      dumbbellMesh.subMeshes.add(rightSub);

      final dumbbellEntity = addMesh(dumbbellMesh, pos);
      physicsSystem.attachEntity(dumbbellEntity, rb);

      // Give it some initial rotation and angular velocity to see it tumble
      rb.setRotation(Quaternion(0.2, 0.3, 0.1, 1.0));
      rb.setAngularVelocity(
        Vector3(_random.nextDouble() * 6 - 3, _random.nextDouble() * 6 - 3, _random.nextDouble() * 6 + 6),
      );
    }
  }

  @override
  void update(double delta) {
    // Spawn dumbbells at 10/sec from (0, 0, 20) up to _maxSpawned
    if (_spawnedCount < _maxSpawned) {
      _spawnAccum += delta;
      while (_spawnAccum >= _spawnInterval && _spawnedCount < _maxSpawned) {
        addDumbbell(_spawnOrigin);
        _spawnedCount++;
        _spawnAccum -= _spawnInterval;
      }
    }
    super.update(delta);
  }
}
