import 'collider.dart';
import 'joint.dart';
import 'rapier_world.dart';

class RigidBody {
  final int handle;
  final RapierWorld world;

  RigidBody(this.handle, this.world);

  /// All colliders attached to this rigid body.
  List<Collider> get colliders => world.getBodyColliders(this);

  /// All joints attached to this rigid body.
  List<Joint> get joints => world.getBodyJoints(this);

  double _linearDamping = 0.0;
  double _angularDamping = 0.0;

  /// Linear damping coefficient. 0 = no damping.
  double get linearDamping => _linearDamping;
  set linearDamping(double value) {
    _linearDamping = value;
    RapierWorld.bindings.setBodyLinearDamping(world.worldHandle, handle, value);
  }

  /// Angular damping coefficient. 0 = no damping.
  double get angularDamping => _angularDamping;
  set angularDamping(double value) {
    _angularDamping = value;
    RapierWorld.bindings.setBodyAngularDamping(world.worldHandle, handle, value);
  }

  Vector3 get position => RapierWorld.bindings.getBodyPosition(world.worldHandle, handle);
  void setPosition(Vector3 position) =>
      RapierWorld.bindings.setBodyPosition(world.worldHandle, handle, position.x, position.y, position.z);

  Quaternion get rotation => RapierWorld.bindings.getBodyRotation(world.worldHandle, handle);
  void setRotation(Quaternion rotation) =>
      RapierWorld.bindings.setBodyRotation(world.worldHandle, handle, rotation.x, rotation.y, rotation.z, rotation.w);

  /// Force this body out of sleep so physics forces and motors take immediate effect.
  void wakeUp() {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.wakeBody(world.worldHandle, handle);
    }
  }

  /// Enable/disable Continuous Collision Detection (CCD) for this body.
  /// CCD prevents fast-moving objects from tunneling through other objects.
  void setCCD(bool enabled) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.setBodyCCD(world.worldHandle, handle, enabled);
    }
  }

  void addForce(Vector3 force) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.addForce(world.worldHandle, handle, force.x, force.y, force.z);
    }
  }

  void addTorque(Vector3 torque) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.addTorque(world.worldHandle, handle, torque.x, torque.y, torque.z);
    }
  }

  void applyImpulse(Vector3 impulse) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.applyImpulse(world.worldHandle, handle, impulse.x, impulse.y, impulse.z);
    }
  }

  void applyTorqueImpulse(Vector3 impulse) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.applyTorqueImpulse(world.worldHandle, handle, impulse.x, impulse.y, impulse.z);
    }
  }

  void addForceAtPoint(Vector3 force, Vector3 point) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.addForceAtPoint(
        world.worldHandle,
        handle,
        force.x,
        force.y,
        force.z,
        point.x,
        point.y,
        point.z,
      );
    }
  }

  void applyImpulseAtPoint(Vector3 impulse, Vector3 point) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.applyImpulseAtPoint(
        world.worldHandle,
        handle,
        impulse.x,
        impulse.y,
        impulse.z,
        point.x,
        point.y,
        point.z,
      );
    }
  }

  void setLinearVelocity(Vector3 velocity) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.setBodyLinearVelocity(world.worldHandle, handle, velocity.x, velocity.y, velocity.z);
    }
  }

  void setAngularVelocity(Vector3 velocity) {
    if (world.worldHandle != 0) {
      RapierWorld.bindings.setBodyAngularVelocity(world.worldHandle, handle, velocity.x, velocity.y, velocity.z);
    }
  }
}
