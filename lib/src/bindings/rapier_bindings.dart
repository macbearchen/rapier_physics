import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_desc.dart';
import '../collider_desc.dart';

abstract class RapierBindings {
  Future<void> init();
  String getVersion();

  // --- World ---
  int createWorld();
  void setGravity(int world, double x, double y, double z);
  void destroyWorld(int world);
  void stepWorld(int world);

  // --- RigidBody ---
  int createRigidBody(int world, RigidBodyDesc desc);
  void removeRigidBody(int world, int handle);

  Vector3 getBodyPosition(int world, int body);
  Quaternion getBodyRotation(int world, int body);

  void setBodyPosition(int world, int body, double x, double y, double z);
  void setBodyRotation(int world, int body, double x, double y, double z, double w);
  void setBodyLinearDamping(int world, int handle, double damping);
  void setBodyAngularDamping(int world, int handle, double damping);
  void setBodyCCD(int world, int body, bool enabled);
  void wakeBody(int world, int body);

  void addForce(int world, int handle, double x, double y, double z);
  void addTorque(int world, int handle, double x, double y, double z);
  void applyImpulse(int world, int handle, double x, double y, double z);
  void applyTorqueImpulse(int world, int handle, double x, double y, double z);
  void addForceAtPoint(int world, int handle, double fx, double fy, double fz, double px, double py, double pz);
  void applyImpulseAtPoint(int world, int handle, double ix, double iy, double iz, double px, double py, double pz);

  void setBodyLinearVelocity(int world, int handle, double x, double y, double z);
  void setBodyAngularVelocity(int world, int handle, double x, double y, double z);

  // --- Collider ---
  int createCollider(int world, int body, ColliderDesc desc);

  int createHeightfieldCollider(
    int world,
    int body,
    Float32List heights,
    int nrows,
    int ncols,
    double sx,
    double sy,
    double sz,
  );
  void removeCollider(int world, int handle);

  Vector3 getColliderPosition(int world, int handle);
  Quaternion getColliderRotation(int world, int handle);
  double getColliderFriction(int world, int handle);
  double getColliderRestitution(int world, int handle);
  double getColliderDensity(int world, int handle);

  void setColliderFriction(int world, int handle, double friction);
  void setColliderRestitution(int world, int handle, double restitution);
  void setColliderDensity(int world, int handle, double density);
  void setColliderPosition(int world, int handle, double x, double y, double z);
  void setColliderRotation(int world, int handle, double x, double y, double z, double w);

  // --- Joint ---
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
  );
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
  );
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
  );
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
  );
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
  );
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
  );
  void removeJoint(int world, int handle);

  void lockJointAxis(int world, int joint, int axis, bool locked);
  void setJointLimits(int world, int joint, int axis, double min, double max);
  void configureJointMotor(
    int world,
    int joint,
    int axis,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  );

  void configureRevoluteJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  );
  void configurePrismaticJointMotor(
    int world,
    int joint,
    double targetPos,
    double targetVel,
    double stiffness,
    double damping,
  );
}
