import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_type.dart';
import 'rapier_bindings.dart';

class RapierBindingsImpl extends RapierBindings {
  @override
  String getVersion() => throw UnsupportedError('Stub');
  @override
  int createWorld() => throw UnsupportedError('Stub');
  @override
  void setGravity(int world, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void destroyWorld(int world) => throw UnsupportedError('Stub');
  @override
  void stepWorld(int world) => throw UnsupportedError('Stub');
  @override
  int createRigidBody(int world, double x, double y, double z, RigidBodyType type) => throw UnsupportedError('Stub');
  @override
  int createBoxCollider(int world, int body, double hx, double hy, double hz) => throw UnsupportedError('Stub');
  @override
  int createSphereCollider(int world, int body, double radius) => throw UnsupportedError('Stub');
  @override
  int createCylinderCollider(int world, int body, double halfHeight, double radius) => throw UnsupportedError('Stub');
  @override
  int createConeCollider(int world, int body, double halfHeight, double radius) => throw UnsupportedError('Stub');
  @override
  int createCapsuleCollider(int world, int body, double halfHeight, double radius) => throw UnsupportedError('Stub');
  @override
  int createHeightfieldCollider(
    int world,
    int body,
    Float32List heights,
    int nrows,
    int ncols,
    double sx,
    double sy,
    double sz,
  ) => throw UnsupportedError('Stub');
  @override
  int createFixedJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double r1x,
    double r1y,
    double r1z,
    double r1w,
    double a2x,
    double a2y,
    double a2z,
    double r2x,
    double r2y,
    double r2z,
    double r2w,
  ) => throw UnsupportedError('Stub');
  @override
  int createSphericalJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => throw UnsupportedError('Stub');
  @override
  int createRevoluteJoint(
    int world,
    int body1,
    int body2,
    double vx,
    double vy,
    double vz,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => throw UnsupportedError('Stub');
  @override
  int createPrismaticJoint(
    int world,
    int body1,
    int body2,
    double vx,
    double vy,
    double vz,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => throw UnsupportedError('Stub');
  @override
  void configureRevoluteJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => throw UnsupportedError('Stub');
  @override
  void configurePrismaticJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => throw UnsupportedError('Stub');
  @override
  int createGenericJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
  ) => throw UnsupportedError('Stub');
  @override
  int createRopeJoint(
    int world,
    int body1,
    int body2,
    double a1x,
    double a1y,
    double a1z,
    double a2x,
    double a2y,
    double a2z,
    double maxDist,
  ) => throw UnsupportedError('Stub');
  @override
  void lockJointAxis(int world, int joint, int axis, bool locked) => throw UnsupportedError('Stub');
  @override
  void setJointLimits(int world, int joint, int axis, double min, double max) => throw UnsupportedError('Stub');
  @override
  void configureJointMotor(
    int world,
    int joint,
    int axis,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  ) => throw UnsupportedError('Stub');
  @override
  Vector3 getBodyPosition(int world, int body) => throw UnsupportedError('Stub');
  @override
  Quaternion getBodyRotation(int world, int body) => throw UnsupportedError('Stub');
  @override
  void setBodyPosition(int world, int body, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) => throw UnsupportedError('Stub');
  @override
  void setBodyCCD(int world, int body, bool enabled) => throw UnsupportedError('Stub');
  @override
  void wakeBody(int world, int body) => throw UnsupportedError('Stub');
  @override
  void setColliderFriction(int world, int handle, double friction) => throw UnsupportedError('Stub');
  @override
  void setColliderRestitution(int world, int handle, double restitution) => throw UnsupportedError('Stub');
  @override
  void setColliderDensity(int world, int handle, double density) => throw UnsupportedError('Stub');
  @override
  void setBodyLinearDamping(int world, int handle, double damping) => throw UnsupportedError('Stub');
  @override
  void setBodyAngularDamping(int world, int handle, double damping) => throw UnsupportedError('Stub');
  @override
  void addForce(int world, int handle, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void addTorque(int world, int handle, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void applyImpulse(int world, int handle, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void applyTorqueImpulse(int world, int handle, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void addForceAtPoint(int world, int handle, double fx, double fy, double fz, double px, double py, double pz) => throw UnsupportedError('Stub');
  @override
  void applyImpulseAtPoint(int world, int handle, double ix, double iy, double iz, double px, double py, double pz) => throw UnsupportedError('Stub');
  @override
  void setBodyLinearVelocity(int world, int handle, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void setBodyAngularVelocity(int world, int handle, double x, double y, double z) => throw UnsupportedError('Stub');
  @override
  void removeRigidBody(int world, int handle) => throw UnsupportedError('Stub');
  @override
  void removeCollider(int world, int handle) => throw UnsupportedError('Stub');
  @override
  void removeJoint(int world, int handle) => throw UnsupportedError('Stub');
  @override
  Future<void> init() async {}
}
