part of 'rapier_bindings_impl.dart';

// ==========================================
// Native (C) Signatures
// (Shared: _WakeBodyC, _GetVec3C, _GetQuatC, _ColliderDesc — native_types.dart)
// ==========================================
typedef _GetFloatC = Float Function(Pointer<Void>, Uint32);
typedef _CreateColliderC = Uint32 Function(Pointer<Void>, Uint32, Pointer<_ColliderDesc>);
typedef _CreateHeightfieldColliderC =
    Uint32 Function(Pointer<Void>, Uint32, Pointer<Float>, Size, Size, Float, Float, Float);
typedef _SetColliderFrictionC = Void Function(Pointer<Void>, Uint32, Float);
typedef _SetColliderRestitutionC = Void Function(Pointer<Void>, Uint32, Float);
typedef _SetColliderDensityC = Void Function(Pointer<Void>, Uint32, Float);
typedef _SetColliderPositionC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _SetColliderRotationC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float);

// ==========================================
// Dart Signatures
// ==========================================
typedef _GetFloatDart = double Function(Pointer<Void>, int);
typedef _CreateColliderDart = int Function(Pointer<Void>, int, Pointer<_ColliderDesc>);
typedef _CreateHeightfieldColliderDart =
    int Function(Pointer<Void>, int, Pointer<Float>, int, int, double, double, double);
typedef _SetColliderFrictionDart = void Function(Pointer<Void>, int, double);
typedef _SetColliderRestitutionDart = void Function(Pointer<Void>, int, double);
typedef _SetColliderDensityDart = void Function(Pointer<Void>, int, double);
typedef _SetColliderPositionDart = void Function(Pointer<Void>, int, double, double, double);
typedef _SetColliderRotationDart = void Function(Pointer<Void>, int, double, double, double, double);

/// FFI bindings for `Collider`: creation (including heightfields), removal,
/// transform, and physical material properties (friction/restitution/density).
mixin ColliderBindings on FfiBindingsBase {
  late _CreateColliderDart _createColliderNative;
  late _CreateHeightfieldColliderDart _createHeightfieldColliderNative;
  late _WakeBodyDart _removeColliderNative;
  late _GetVec3Dart _getColliderPositionNative;
  late _GetQuatDart _getColliderRotationNative;
  late _GetFloatDart _getColFriction;
  late _GetFloatDart _getColRestitution;
  late _GetFloatDart _getColDensity;
  late _SetColliderFrictionDart _setColliderFrictionNative;
  late _SetColliderRestitutionDart _setColliderRestitutionNative;
  late _SetColliderDensityDart _setColliderDensityNative;
  late _SetColliderPositionDart _setColliderPositionNative;
  late _SetColliderRotationDart _setColliderRotationNative;

  void initColliderBindings() {
    _createColliderNative = dylib.lookupFunction<_CreateColliderC, _CreateColliderDart>('rapier_collider_create');
    _createHeightfieldColliderNative = dylib
        .lookupFunction<_CreateHeightfieldColliderC, _CreateHeightfieldColliderDart>(
          'rapier_collider_create_heightfield',
        );
    _removeColliderNative = dylib.lookupFunction<_WakeBodyC, _WakeBodyDart>('rapier_collider_remove');
    _getColliderPositionNative = dylib.lookupFunction<_GetVec3C, _GetVec3Dart>('rapier_collider_get_position');
    _getColliderRotationNative = dylib.lookupFunction<_GetQuatC, _GetQuatDart>('rapier_collider_get_rotation');
    _getColFriction = dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_collider_get_friction');
    _getColRestitution = dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_collider_get_restitution');
    _getColDensity = dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_collider_get_density');
    _setColliderFrictionNative =
        dylib.lookupFunction<_SetColliderFrictionC, _SetColliderFrictionDart>('rapier_collider_set_friction');
    _setColliderRestitutionNative = dylib
        .lookupFunction<_SetColliderRestitutionC, _SetColliderRestitutionDart>('rapier_collider_set_restitution');
    _setColliderDensityNative =
        dylib.lookupFunction<_SetColliderDensityC, _SetColliderDensityDart>('rapier_collider_set_density');
    _setColliderPositionNative =
        dylib.lookupFunction<_SetColliderPositionC, _SetColliderPositionDart>('rapier_collider_set_position');
    _setColliderRotationNative =
        dylib.lookupFunction<_SetColliderRotationC, _SetColliderRotationDart>('rapier_collider_set_rotation');
  }

  int createCollider(int world, int body, ColliderDesc desc) {
    final nativeDesc = calloc<_ColliderDesc>();
    nativeDesc.ref.shapeType = desc.shapeType.index;
    nativeDesc.ref.hx = desc.hx;
    nativeDesc.ref.hy = desc.hy;
    nativeDesc.ref.hz = desc.hz;
    nativeDesc.ref.radius = desc.radius;
    nativeDesc.ref.halfHeight = desc.halfHeight;
    nativeDesc.ref.friction = desc.friction;
    nativeDesc.ref.restitution = desc.restitution;
    nativeDesc.ref.density = desc.density;
    nativeDesc.ref.localPositionX = desc.localPosition.x;
    nativeDesc.ref.localPositionY = desc.localPosition.y;
    nativeDesc.ref.localPositionZ = desc.localPosition.z;
    nativeDesc.ref.localRotationX = desc.localRotation.x;
    nativeDesc.ref.localRotationY = desc.localRotation.y;
    nativeDesc.ref.localRotationZ = desc.localRotation.z;
    nativeDesc.ref.localRotationW = desc.localRotation.w;
    nativeDesc.ref.isSensor = desc.isSensor;

    final handle = _createColliderNative(Pointer<Void>.fromAddress(world), body, nativeDesc);

    calloc.free(nativeDesc);
    return handle;
  }

  int createHeightfieldCollider(
    int world,
    int body,
    Float32List heights,
    int nrows,
    int ncols,
    double sx,
    double sy,
    double sz,
  ) {
    final pointer = calloc<Float>(heights.length);
    pointer.asTypedList(heights.length).setAll(0, heights);
    final handle = _createHeightfieldColliderNative(
      Pointer<Void>.fromAddress(world),
      body,
      pointer,
      nrows,
      ncols,
      sx,
      sy,
      sz,
    );
    calloc.free(pointer);
    return handle;
  }

  void removeCollider(int world, int handle) => _removeColliderNative(Pointer<Void>.fromAddress(world), handle);

  Vector3 getColliderPosition(int world, int handle) {
    final worldPtr = Pointer<Void>.fromAddress(world);
    final pos = _getColliderPositionNative(worldPtr, handle);
    return Vector3(pos.x, pos.y, pos.z);
  }

  Quaternion getColliderRotation(int world, int handle) {
    final worldPtr = Pointer<Void>.fromAddress(world);
    final rot = _getColliderRotationNative(worldPtr, handle);
    return Quaternion(rot.x, rot.y, rot.z, rot.w);
  }

  double getColliderFriction(int world, int handle) => _getColFriction(Pointer<Void>.fromAddress(world), handle);

  double getColliderRestitution(int world, int handle) => _getColRestitution(Pointer<Void>.fromAddress(world), handle);

  double getColliderDensity(int world, int handle) => _getColDensity(Pointer<Void>.fromAddress(world), handle);

  void setColliderFriction(int world, int handle, double friction) =>
      _setColliderFrictionNative(Pointer<Void>.fromAddress(world), handle, friction);

  void setColliderRestitution(int world, int handle, double restitution) =>
      _setColliderRestitutionNative(Pointer<Void>.fromAddress(world), handle, restitution);

  void setColliderDensity(int world, int handle, double density) =>
      _setColliderDensityNative(Pointer<Void>.fromAddress(world), handle, density);

  void setColliderPosition(int world, int handle, double x, double y, double z) =>
      _setColliderPositionNative(Pointer<Void>.fromAddress(world), handle, x, y, z);

  void setColliderRotation(int world, int handle, double x, double y, double z, double w) =>
      _setColliderRotationNative(Pointer<Void>.fromAddress(world), handle, x, y, z, w);
}
