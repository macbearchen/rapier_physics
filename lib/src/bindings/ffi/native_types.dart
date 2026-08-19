part of 'rapier_bindings_impl.dart';

// Structs and typedefs shared by 2+ domain mixins. Because all part files
// share one library's private (`_`) namespace, each of these must be
// declared exactly once here rather than duplicated per file.

// Vec3 returned by value — used by RigidBody, Collider, CharacterController.
final class _Vec3Struct extends Struct {
  @Float()
  external double x;
  @Float()
  external double y;
  @Float()
  external double z;
}

// Quat returned by value — used by RigidBody, Collider.
final class _QuatStruct extends Struct {
  @Float()
  external double x;
  @Float()
  external double y;
  @Float()
  external double z;
  @Float()
  external double w;
}

// Collider descriptor struct passed by pointer — used by Collider, SceneQuery.
final class _ColliderDesc extends Struct {
  @Uint32()
  external int shapeType;
  @Float()
  external double hx;
  @Float()
  external double hy;
  @Float()
  external double hz;
  @Float()
  external double radius;
  @Float()
  external double halfHeight;
  @Float()
  external double friction;
  @Float()
  external double restitution;
  @Float()
  external double density;
  @Float()
  external double localPositionX;
  @Float()
  external double localPositionY;
  @Float()
  external double localPositionZ;
  @Float()
  external double localRotationX;
  @Float()
  external double localRotationY;
  @Float()
  external double localRotationZ;
  @Float()
  external double localRotationW;
  @Bool()
  external bool isSensor;
}

// Generic "handle in, nothing out" signature — used for remove/wake calls
// across RigidBody, Collider, and Joint.
typedef _WakeBodyC = Void Function(Pointer<Void>, Uint32);
typedef _WakeBodyDart = void Function(Pointer<Void>, int);

// Position/rotation getters — used by RigidBody and Collider.
typedef _GetVec3C = _Vec3Struct Function(Pointer<Void>, Uint32);
typedef _GetVec3Dart = _Vec3Struct Function(Pointer<Void>, int);
typedef _GetQuatC = _QuatStruct Function(Pointer<Void>, Uint32);
typedef _GetQuatDart = _QuatStruct Function(Pointer<Void>, int);
