import 'dart:typed_data';
import 'package:rapier_physics/src/collider_desc.dart';

import 'bindings/rapier_bindings.dart';
import 'bindings/rapier_bindings_stub.dart'
    if (dart.library.ffi) 'bindings/rapier_bindings_ffi.dart'
    if (dart.library.js_interop) 'bindings/rapier_bindings_web.dart'
    as rapier_bindings;

import 'package:vector_math/vector_math.dart' show Vector3, Quaternion;
export 'package:vector_math/vector_math.dart' show Vector3, Quaternion;

import 'collider.dart';
import 'joint.dart';
import 'joint_axis.dart';
import 'rigid_body.dart';
import 'rigid_body_desc.dart';

class RapierWorld {
  static final RapierBindings bindings = rapier_bindings.RapierBindingsImpl();
  int _worldHandle = 0;
  int _groundBodyHandle = 0;

  int get worldHandle => _worldHandle;

  RigidBody get groundBody => RigidBody(_groundBodyHandle, this);

  final Map<RigidBody, List<Collider>> _bodyColliders = {};
  final Map<RigidBody, List<Joint>> _bodyJoints = {};
  final List<RigidBody> _bodies = [];
  final List<Collider> _colliders = [];
  final List<Joint> _joints = [];

  RapierWorld();

  Future<void> init({Vector3? gravity}) async {
    await RapierWorld.bindings.init();
    _worldHandle = RapierWorld.bindings.createWorld();
    _groundBodyHandle = RapierWorld.bindings.createRigidBody(_worldHandle, RigidBodyDesc.fixed());
    if (gravity != null) {
      setGravity(gravity.x, gravity.y, gravity.z);
    }
  }

  void setGravity(double x, double y, double z) {
    if (_worldHandle != 0) {
      bindings.setGravity(_worldHandle, x, y, z);
    }
  }

  void destroy() {
    if (_worldHandle != 0) {
      bindings.destroyWorld(_worldHandle);
      _worldHandle = 0;
      _groundBodyHandle = 0;
    }
  }

  String get version => bindings.getVersion();

  void step() {
    if (_worldHandle != 0) {
      bindings.stepWorld(_worldHandle);
    }
  }

  RigidBody createRigidBody(RigidBodyDesc desc) {
    final handle = bindings.createRigidBody(_worldHandle, desc);
    final body = RigidBody(handle, this);
    _bodies.add(body);
    return body;
  }

  //--------------------------
  // add rigid body with collider related
  //--------------------------

  RigidBody addBox({
    required double hx,
    required double hy,
    required double hz,
    RigidBodyDesc? desc,
  }) {
    final body = createRigidBody(desc ?? RigidBodyDesc.dynamic());
    createCollider(body, ColliderDesc.cuboid(hx, hy, hz));
    return body;
  }

  RigidBody addSphere({
    required double radius,
    RigidBodyDesc? desc,
  }) {
    final body = createRigidBody(desc ?? RigidBodyDesc.dynamic());
    createCollider(body, ColliderDesc.ball(radius));
    return body;
  }

  RigidBody addCylinder({
    required double halfHeight,
    required double radius,
    RigidBodyDesc? desc,
  }) {
    final body = createRigidBody(desc ?? RigidBodyDesc.dynamic());
    createCollider(body, ColliderDesc.cylinder(halfHeight, radius));
    return body;
  }

  RigidBody addCone({
    required double halfHeight,
    required double radius,
    RigidBodyDesc? desc,
  }) {
    final body = createRigidBody(desc ?? RigidBodyDesc.dynamic());
    createCollider(body, ColliderDesc.cone(halfHeight, radius));
    return body;
  }

  RigidBody addCapsule({
    required double halfHeight,
    required double radius,
    RigidBodyDesc? desc,
  }) {
    final body = createRigidBody(desc ?? RigidBodyDesc.dynamic());
    createCollider(body, ColliderDesc.capsule(halfHeight, radius));
    return body;
  }

  RigidBody addHeightfield({
    required Float32List heights,
    required int nrows,
    required int ncols,
    required Vector3 scale,
    RigidBodyDesc? desc,
  }) {
    final body = createRigidBody(desc ?? RigidBodyDesc.fixed());
    createHeightfieldCollider(body, heights, nrows, ncols, scale);
    return body;
  }

  //--------------------------
  // create collider by shape type
  //--------------------------

  Collider createCollider(RigidBody body, ColliderDesc desc) {
    final handle = bindings.createCollider(_worldHandle, body.handle, desc);
    final collider = Collider(handle, body);
    _registerCollider(collider);
    return collider;
  }

  Collider createHeightfieldCollider(RigidBody body, Float32List heights, int nrows, int ncols, Vector3 scale) {
    final handle = bindings.createHeightfieldCollider(
      _worldHandle,
      body.handle,
      heights,
      nrows,
      ncols,
      scale.x,
      scale.y,
      scale.z,
    );
    final collider = HeightfieldCollider(handle, body);
    _registerCollider(collider);
    return collider;
  }

  //--------------------------
  // register collider, joint mapping related
  //--------------------------

  void _registerCollider(Collider collider) {
    _colliders.add(collider);
    _bodyColliders.putIfAbsent(collider.body, () => []).add(collider);
  }

  /// Returns all colliders attached to a given rigid body.
  List<Collider> getBodyColliders(RigidBody body) => _bodyColliders[body] ?? [];

  void _registerJoint(Joint joint) {
    _joints.add(joint);
    _bodyJoints.putIfAbsent(joint.body1, () => []).add(joint);
    _bodyJoints.putIfAbsent(joint.body2, () => []).add(joint);
  }

  /// Returns all joints attached to a given rigid body.
  List<Joint> getBodyJoints(RigidBody body) => _bodyJoints[body] ?? [];

  //--------------------------
  // add joint related
  //--------------------------

  /// Fixed joint — locks two bodies with no relative movement.
  FixedJoint addFixedJoint(
    RigidBody body1,
    RigidBody body2,
    Vector3 anchor1,
    Quaternion rot1,
    Vector3 anchor2,
    Quaternion rot2,
  ) {
    final handle = bindings.createFixedJoint(
      _worldHandle,
      body1.handle,
      body2.handle,
      anchor1.x,
      anchor1.y,
      anchor1.z,
      rot1.x,
      rot1.y,
      rot1.z,
      rot1.w,
      anchor2.x,
      anchor2.y,
      anchor2.z,
      rot2.x,
      rot2.y,
      rot2.z,
      rot2.w,
    );
    final joint = FixedJoint(handle, body1, body2);
    _registerJoint(joint);
    return joint;
  }

  /// Spherical joint — allows free rotation in all directions (ball-and-socket).
  SphericalJoint addSphericalJoint(RigidBody body1, RigidBody body2, Vector3 anchor1, Vector3 anchor2) {
    final handle = bindings.createSphericalJoint(
      _worldHandle,
      body1.handle,
      body2.handle,
      anchor1.x,
      anchor1.y,
      anchor1.z,
      anchor2.x,
      anchor2.y,
      anchor2.z,
    );
    final joint = SphericalJoint(handle, body1, body2);
    _registerJoint(joint);
    return joint;
  }

  /// Revolute joint — allows rotation around a single axis (hinge).
  RevoluteJoint addRevoluteJoint(RigidBody body1, RigidBody body2, Vector3 axis, Vector3 anchor1, Vector3 anchor2) {
    final handle = bindings.createRevoluteJoint(
      _worldHandle,
      body1.handle,
      body2.handle,
      axis.x,
      axis.y,
      axis.z,
      anchor1.x,
      anchor1.y,
      anchor1.z,
      anchor2.x,
      anchor2.y,
      anchor2.z,
    );
    final joint = RevoluteJoint(handle, body1, body2, axis);
    _registerJoint(joint);
    return joint;
  }

  /// Prismatic joint — allows translation along a single axis (slider).
  PrismaticJoint addPrismaticJoint(RigidBody body1, RigidBody body2, Vector3 axis, Vector3 anchor1, Vector3 anchor2) {
    final handle = bindings.createPrismaticJoint(
      _worldHandle,
      body1.handle,
      body2.handle,
      axis.x,
      axis.y,
      axis.z,
      anchor1.x,
      anchor1.y,
      anchor1.z,
      anchor2.x,
      anchor2.y,
      anchor2.z,
    );
    final joint = PrismaticJoint(handle, body1, body2, axis);
    _registerJoint(joint);
    return joint;
  }

  /// Generic joint — all axes configurable via [lockJointAxis] and [setJointLimits].
  GenericJoint addGenericJoint(RigidBody body1, RigidBody body2, Vector3 anchor1, Vector3 anchor2) {
    final handle = bindings.createGenericJoint(
      _worldHandle,
      body1.handle,
      body2.handle,
      anchor1.x,
      anchor1.y,
      anchor1.z,
      anchor2.x,
      anchor2.y,
      anchor2.z,
    );
    final joint = GenericJoint(handle, body1, body2);
    _registerJoint(joint);
    return joint;
  }

  /// Rope joint — constrains two bodies within a maximum distance.
  RopeJoint addRopeJoint(RigidBody body1, RigidBody body2, Vector3 anchor1, Vector3 anchor2, double maxDistance) {
    final handle = bindings.createRopeJoint(
      _worldHandle,
      body1.handle,
      body2.handle,
      anchor1.x,
      anchor1.y,
      anchor1.z,
      anchor2.x,
      anchor2.y,
      anchor2.z,
      maxDistance,
    );
    final joint = RopeJoint(handle, body1, body2, maxDistance);
    _registerJoint(joint);
    return joint;
  }

  //--------------------------
  // add joint to world related
  //--------------------------

  /// Pins [body] to a fixed frame using a [FixedJoint] anchored to the world ground.
  FixedJoint addFixedJointToWorld(
    RigidBody body,
    Vector3 localAnchor,
    Quaternion localRot,
    Vector3 worldAnchor,
    Quaternion worldRot,
  ) {
    final ground = groundBody;
    final handle = bindings.createFixedJoint(
      _worldHandle,
      body.handle,
      ground.handle,
      localAnchor.x,
      localAnchor.y,
      localAnchor.z,
      localRot.x,
      localRot.y,
      localRot.z,
      localRot.w,
      worldAnchor.x,
      worldAnchor.y,
      worldAnchor.z,
      worldRot.x,
      worldRot.y,
      worldRot.z,
      worldRot.w,
    );
    final joint = FixedJoint(handle, body, ground);
    _registerJoint(joint);
    return joint;
  }

  /// Pins [body] to a fixed point in world space using a [SphericalJoint].
  SphericalJoint addSphericalJointToWorld(RigidBody body, Vector3 localAnchor, Vector3 worldAnchor) {
    final ground = groundBody;
    final handle = bindings.createSphericalJoint(
      _worldHandle,
      body.handle,
      ground.handle,
      localAnchor.x,
      localAnchor.y,
      localAnchor.z,
      worldAnchor.x,
      worldAnchor.y,
      worldAnchor.z,
    );
    final joint = SphericalJoint(handle, body, ground);
    _registerJoint(joint);
    return joint;
  }

  /// Anchors [body] to the world with a [RevoluteJoint] spinning around [worldAxis].
  RevoluteJoint addRevoluteJointToWorld(RigidBody body, Vector3 worldAxis, Vector3 localAnchor, Vector3 worldAnchor) {
    final ground = groundBody;
    final handle = bindings.createRevoluteJoint(
      _worldHandle,
      body.handle,
      ground.handle,
      worldAxis.x,
      worldAxis.y,
      worldAxis.z,
      localAnchor.x,
      localAnchor.y,
      localAnchor.z,
      worldAnchor.x,
      worldAnchor.y,
      worldAnchor.z,
    );
    final joint = RevoluteJoint(handle, body, ground, worldAxis);
    _registerJoint(joint);
    return joint;
  }

  /// Anchors [body] to the world with a [PrismaticJoint] sliding along [worldAxis].
  PrismaticJoint addPrismaticJointToWorld(RigidBody body, Vector3 worldAxis, Vector3 localAnchor, Vector3 worldAnchor) {
    final ground = groundBody;
    final handle = bindings.createPrismaticJoint(
      _worldHandle,
      body.handle,
      ground.handle,
      worldAxis.x,
      worldAxis.y,
      worldAxis.z,
      localAnchor.x,
      localAnchor.y,
      localAnchor.z,
      worldAnchor.x,
      worldAnchor.y,
      worldAnchor.z,
    );
    final joint = PrismaticJoint(handle, body, ground, worldAxis);
    _registerJoint(joint);
    return joint;
  }

  //--------------------------
  // joint limits related
  //--------------------------

  void lockJointAxis(Joint joint, JointAxis axis, bool locked) {
    bindings.lockJointAxis(_worldHandle, joint.handle, axis.index, locked);
  }

  void setJointLimits(Joint joint, JointAxis axis, double min, double max) {
    bindings.setJointLimits(_worldHandle, joint.handle, axis.index, min, max);
  }

  //--------------------------
  // configure motor related
  //--------------------------

  void configureRevoluteMotor(
    RevoluteJoint joint, {
    double targetPos = 0,
    double targetVel = 0,
    double stiffness = 0,
    double damping = 0,
  }) {
    bindings.configureRevoluteJointMotor(_worldHandle, joint.handle, targetPos, targetVel, stiffness, damping);
  }

  void configurePrismaticMotor(
    PrismaticJoint joint, {
    double targetPos = 0,
    double targetVel = 0,
    double stiffness = 0,
    double damping = 0,
  }) {
    bindings.configurePrismaticJointMotor(_worldHandle, joint.handle, targetPos, targetVel, stiffness, damping);
  }

  void configureJointMotor(
    Joint joint,
    JointAxis axis, {
    double targetPos = 0,
    double targetVel = 0,
    double stiffness = 0,
    double damping = 0,
  }) {
    bindings.configureJointMotor(_worldHandle, joint.handle, axis.index, targetPos, targetVel, stiffness, damping);
  }

  //--------------------------
  // remove rigid body, collider, joint related
  //--------------------------

  void removeRigidBody(RigidBody rb) {
    if (_worldHandle != 0) {
      // 1. Remove attached colliders from our tracking
      final attachedColliders = getBodyColliders(rb);
      for (final c in attachedColliders) {
        _colliders.remove(c);
      }
      _bodyColliders.remove(rb);

      // 2. Remove attached joints from our tracking
      final attachedJoints = getBodyJoints(rb);
      for (final j in attachedJoints) {
        _joints.remove(j);
        // Also remove from the OTHER body's joint list
        final other = (j.body1 == rb) ? j.body2 : j.body1;
        _bodyJoints[other]?.remove(j);
      }
      _bodyJoints.remove(rb);

      // 3. Remove from native world
      bindings.removeRigidBody(_worldHandle, rb.handle);

      // 4. Remove from our list
      _bodies.remove(rb);
    }
  }

  void removeCollider(Collider c) {
    if (_worldHandle != 0) {
      bindings.removeCollider(_worldHandle, c.handle);
      _colliders.remove(c);
      _bodyColliders[c.body]?.remove(c);
    }
  }

  void removeJoint(Joint j) {
    if (_worldHandle != 0) {
      bindings.removeJoint(_worldHandle, j.handle);
      _joints.remove(j);
      _bodyJoints[j.body1]?.remove(j);
      _bodyJoints[j.body2]?.remove(j);
    }
  }
}
