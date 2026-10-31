import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_desc.dart';
import '../collider_desc.dart';

abstract class RapierBindings {
  // ==========================================
  // Initialization & Version
  // ==========================================

  Future<void> init();
  String getVersion();

  // ==========================================
  // World
  // ==========================================

  int createWorld();
  void setGravity(int world, double x, double y, double z);
  void destroyWorld(int world);
  void stepWorld(int world);
  double getTimestep(int world);
  void setTimestep(int world, double dt);

  // ==========================================
  // Rigid Body
  // ==========================================

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

  // ==========================================
  // Collider
  // ==========================================

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

  // ==========================================
  // Joint
  // ==========================================

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

  // ==========================================
  // Kinematic Character Controller
  // ==========================================

  /// Allocates a new KinematicCharacterController. [offset] is the skin distance
  /// (distance kept between the character and surfaces, e.g. 0.01).
  int createCharacterController(double offset);

  /// Frees a previously created controller.
  void destroyCharacterController(int ctrl);

  /// Sets the world-space "up" axis used by the controller.
  void setCharacterControllerUp(int ctrl, double x, double y, double z);

  /// Maximum slope angle (radians) the character can climb.
  void setCharacterControllerMaxSlope(int ctrl, double angleRadians);

  /// Minimum slope angle (radians) below which sliding is suppressed.
  void setCharacterControllerMinSlope(int ctrl, double angleRadians);

  /// Enable/disable ground-snapping (pulls the character toward the ground when
  /// falling small distances so it doesn't float off steps).
  void setCharacterControllerSnapToGround(int ctrl, double distance, bool enabled);

  /// Enable/disable automatic step-climbing.
  /// Set [maxHeight] ≤ 0 to disable.
  void setCharacterControllerAutoStep(int ctrl, double maxHeight, double minWidth, bool includeDynamicBodies);

  /// Compute the corrected movement for the character this frame.
  ///
  /// The character's own [colliderHandle] is excluded from the sweep query.
  /// Returns the effective (collision-resolved) movement vector.
  Vector3 moveCharacter(int world, int ctrl, int colliderHandle, double dx, double dy, double dz, double dt);

  /// Returns true if the character was touching the ground after the last [moveCharacter] call.
  bool isCharacterGrounded(int ctrl);

  /// Returns true if the character was touching a wall after the last [moveCharacter] call.
  bool isCharacterOnWall(int ctrl);

  /// Returns true if the character was touching a ceiling after the last [moveCharacter] call.
  bool isCharacterOnCeiling(int ctrl);

  // ==========================================
  // Dynamic Ray-Cast Vehicle Controller
  // ==========================================

  /// Creates a new vehicle controller for the given chassis rigid body.
  ///
  /// [chassisHandle] is the raw rigid-body handle index (generation-0).
  /// [upAxis] and [forwardAxis] select the chassis-local *up* / *forward*
  /// axes: 0 = X, 1 = Y, 2 = Z.
  int createVehicle(int chassisHandle, int upAxis, int forwardAxis);

  /// Frees a vehicle controller previously created with [createVehicle].
  void destroyVehicle(int vehicle);

  /// Adds a wheel to the vehicle and returns its 0-based index.
  ///
  /// [connectionX/Y/Z] — chassis-local attachment point.
  /// [directionX/Y/Z]  — suspension ray-cast direction (chassis space;
  ///                      typically pointing *down*, e.g. `(0, -1, 0)`).
  /// [axleX/Y/Z]       — wheel spin axis (chassis space, e.g. `(1, 0, 0)`).
  /// [suspensionRestLength] — unloaded spring length (m).
  /// [radius]           — wheel radius (m).
  ///
  /// Tuning parameters default to rapier's built-in defaults when set to 0.
  int addVehicleWheel(
    int vehicle, {
    required double connectionX,
    required double connectionY,
    required double connectionZ,
    required double directionX,
    required double directionY,
    required double directionZ,
    required double axleX,
    required double axleY,
    required double axleZ,
    required double suspensionRestLength,
    required double radius,
    double suspensionStiffness,
    double suspensionCompression,
    double suspensionDamping,
    double maxSuspensionTravel,
    double frictionSlip,
    double maxSuspensionForce,
  });

  /// Returns the number of wheels attached to the vehicle.
  int vehicleWheelCount(int vehicle);

  /// Sets the steering angle (radians) for the wheel at [wheelIndex].
  void setVehicleSteering(int vehicle, int wheelIndex, double steering);

  /// Sets the engine force for the wheel at [wheelIndex].
  void setVehicleEngineForce(int vehicle, int wheelIndex, double force);

  /// Sets the braking force for the wheel at [wheelIndex].
  void setVehicleBrake(int vehicle, int wheelIndex, double brake);

  /// Advances the vehicle simulation by [dt] seconds.
  /// Must be called **before** [stepWorld] each frame.
  void updateVehicle(int world, int vehicle, double dt);

  /// Returns the spin rotation (radians) of a wheel around its axle.
  double vehicleWheelRotation(int vehicle, int wheelIndex);

  /// Returns the current steering angle (radians) of a wheel.
  double vehicleWheelSteering(int vehicle, int wheelIndex);

  /// Returns the current suspension length of a wheel (metres).
  double vehicleWheelSuspensionLength(int vehicle, int wheelIndex);

  /// Returns true if the wheel is currently touching the ground.
  bool vehicleWheelIsInContact(int vehicle, int wheelIndex);

  /// Returns the world-space center position of a wheel.
  Vector3 vehicleWheelCenter(int vehicle, int wheelIndex);

  /// Returns the world-space ground contact point of a wheel.
  /// Only meaningful when [vehicleWheelIsInContact] is true.
  Vector3 vehicleWheelContactPoint(int vehicle, int wheelIndex);

  /// Returns the world-space contact normal of a wheel.
  Vector3 vehicleWheelContactNormal(int vehicle, int wheelIndex);

  /// Returns the current forward speed of the vehicle (m/s).
  double vehicleCurrentSpeed(int vehicle);

  /// Returns the collider handle of the ground object under a wheel,
  /// or -1 if the wheel is not in contact with anything.
  int vehicleWheelGroundObject(int vehicle, int wheelIndex);

  // ==========================================
  // Scene Queries (QueryPipeline)
  // ==========================================

  RayHitData? castRay(
    int world,
    double ox,
    double oy,
    double oz,
    double dx,
    double dy,
    double dz,
    double maxToi,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  );

  RayHitData? castRayAndGetNormal(
    int world,
    double ox,
    double oy,
    double oz,
    double dx,
    double dy,
    double dz,
    double maxToi,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  );

  ShapeHitData? castShape(
    int world,
    double px,
    double py,
    double pz,
    double rx,
    double ry,
    double rz,
    double rw,
    double vx,
    double vy,
    double vz,
    ColliderDesc desc,
    double maxToi,
    bool stopAtPenetration,
    int excludeCollider,
    int excludeRigidBody,
  );

  PointProjectionData? projectPoint(
    int world,
    double px,
    double py,
    double pz,
    bool solid,
    int excludeCollider,
    int excludeRigidBody,
  );

  List<int> intersectionsWithPoint(
    int world,
    double px,
    double py,
    double pz,
    int excludeCollider,
    int excludeRigidBody,
  );

  int intersectionWithShape(
    int world,
    double px,
    double py,
    double pz,
    double rx,
    double ry,
    double rz,
    double rw,
    ColliderDesc desc,
    int excludeCollider,
    int excludeRigidBody,
  );
}

class RayHitData {
  final int colliderHandle;
  final int rigidBodyHandle;
  final double toi;
  final Vector3 point;
  final Vector3 normal;

  const RayHitData({
    required this.colliderHandle,
    required this.rigidBodyHandle,
    required this.toi,
    required this.point,
    required this.normal,
  });
}

class ShapeHitData {
  final int colliderHandle;
  final int rigidBodyHandle;
  final double toi;
  final Vector3 point;
  final Vector3 normal;

  const ShapeHitData({
    required this.colliderHandle,
    required this.rigidBodyHandle,
    required this.toi,
    required this.point,
    required this.normal,
  });
}

class PointProjectionData {
  final int colliderHandle;
  final int rigidBodyHandle;
  final Vector3 point;
  final bool isInside;

  const PointProjectionData({
    required this.colliderHandle,
    required this.rigidBodyHandle,
    required this.point,
    required this.isInside,
  });
}

