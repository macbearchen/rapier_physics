import 'rigid_body.dart';

class Collider {
  // Currently handles are not used for colliders in the FFI layer as much, 
  // but we can store it if needed.
  final RigidBody body;

  Collider(this.body);
}
