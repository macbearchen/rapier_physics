import 'package:vector_math/vector_math.dart' show Vector3;
import 'rigid_body.dart';

/// Base class for all physics joints.
class Joint {
  final int handle;
  final RigidBody body1;
  final RigidBody body2;

  const Joint(this.handle, this.body1, this.body2);
}

/// Locks two bodies together with no relative movement.
class FixedJoint extends Joint {
  const FixedJoint(super.handle, super.body1, super.body2);
}

/// Allows free rotation in all directions (ball-and-socket).
class SphericalJoint extends Joint {
  const SphericalJoint(super.handle, super.body1, super.body2);
}

/// Allows rotation around a single axis (hinge).
class RevoluteJoint extends Joint {
  final Vector3 axis;
  const RevoluteJoint(super.handle, super.body1, super.body2, this.axis);
}

/// Allows translation along a single axis (slider).
class PrismaticJoint extends Joint {
  final Vector3 axis;
  const PrismaticJoint(super.handle, super.body1, super.body2, this.axis);
}

/// A fully-configurable joint where axes can be individually locked or freed.
class GenericJoint extends Joint {
  const GenericJoint(super.handle, super.body1, super.body2);
}

/// Constrains two bodies within a maximum distance (rope/chain link).
class RopeJoint extends Joint {
  final double maxDistance;
  const RopeJoint(super.handle, super.body1, super.body2, this.maxDistance);
}
