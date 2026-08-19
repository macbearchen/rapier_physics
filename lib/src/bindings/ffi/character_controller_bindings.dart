part of 'rapier_bindings_impl.dart';

// ==========================================
// Native (C) Signatures
// (Shared: _Vec3Struct — declared in native_types.dart)
// ==========================================
typedef _CreateCharacterControllerC = Pointer<Void> Function(Float);
typedef _DestroyCharacterControllerC = Void Function(Pointer<Void>);
typedef _SetCharacterControllerUpC = Void Function(Pointer<Void>, Float, Float, Float);
typedef _SetCharacterControllerSlopeC = Void Function(Pointer<Void>, Float);
typedef _SetCharacterControllerSnapC = Void Function(Pointer<Void>, Float, Bool);
typedef _SetCharacterControllerAutoStepC = Void Function(Pointer<Void>, Float, Float, Bool);
typedef _MoveCharacterC = _Vec3Struct Function(Pointer<Void>, Pointer<Void>, Uint32, Float, Float, Float, Float);
typedef _CharacterBoolC = Bool Function(Pointer<Void>);

// ==========================================
// Dart Signatures
// ==========================================
typedef _CreateCharacterControllerDart = Pointer<Void> Function(double);
typedef _DestroyCharacterControllerDart = void Function(Pointer<Void>);
typedef _SetCharacterControllerUpDart = void Function(Pointer<Void>, double, double, double);
typedef _SetCharacterControllerSlopeDart = void Function(Pointer<Void>, double);
typedef _SetCharacterControllerSnapDart = void Function(Pointer<Void>, double, bool);
typedef _SetCharacterControllerAutoStepDart = void Function(Pointer<Void>, double, double, bool);
typedef _MoveCharacterDart = _Vec3Struct Function(Pointer<Void>, Pointer<Void>, int, double, double, double, double);
typedef _CharacterBoolDart = bool Function(Pointer<Void>);

/// FFI bindings for the kinematic `CharacterController`: creation,
/// configuration (up vector, slope limits, snap-to-ground, auto-step),
/// movement, and ground/wall/ceiling contact queries.
mixin CharacterControllerBindings on FfiBindingsBase {
  late _CreateCharacterControllerDart _createCharacterControllerNative;
  late _DestroyCharacterControllerDart _destroyCharacterControllerNative;
  late _SetCharacterControllerUpDart _setCharacterControllerUpNative;
  late _SetCharacterControllerSlopeDart _setCharacterControllerMaxSlopeNative;
  late _SetCharacterControllerSlopeDart _setCharacterControllerMinSlopeNative;
  late _SetCharacterControllerSnapDart _setCharacterControllerSnapNative;
  late _SetCharacterControllerAutoStepDart _setCharacterControllerAutoStepNative;
  late _MoveCharacterDart _moveCharacterNative;
  late _CharacterBoolDart _isCharacterGroundedNative;
  late _CharacterBoolDart _isCharacterOnWallNative;
  late _CharacterBoolDart _isCharacterOnCeilingNative;

  void initCharacterControllerBindings() {
    _createCharacterControllerNative = dylib
        .lookupFunction<_CreateCharacterControllerC, _CreateCharacterControllerDart>(
          'rapier_character_controller_create',
        );
    _destroyCharacterControllerNative = dylib
        .lookupFunction<_DestroyCharacterControllerC, _DestroyCharacterControllerDart>(
          'rapier_character_controller_destroy',
        );
    _setCharacterControllerUpNative =
        dylib.lookupFunction<_SetCharacterControllerUpC, _SetCharacterControllerUpDart>(
      'rapier_character_controller_set_up',
    );
    _setCharacterControllerMaxSlopeNative = dylib
        .lookupFunction<_SetCharacterControllerSlopeC, _SetCharacterControllerSlopeDart>(
          'rapier_character_controller_set_max_slope',
        );
    _setCharacterControllerMinSlopeNative = dylib
        .lookupFunction<_SetCharacterControllerSlopeC, _SetCharacterControllerSlopeDart>(
          'rapier_character_controller_set_min_slope',
        );
    _setCharacterControllerSnapNative = dylib
        .lookupFunction<_SetCharacterControllerSnapC, _SetCharacterControllerSnapDart>(
          'rapier_character_controller_set_snap_to_ground',
        );
    _setCharacterControllerAutoStepNative = dylib
        .lookupFunction<_SetCharacterControllerAutoStepC, _SetCharacterControllerAutoStepDart>(
          'rapier_character_controller_set_autostep',
        );
    _moveCharacterNative =
        dylib.lookupFunction<_MoveCharacterC, _MoveCharacterDart>('rapier_character_controller_move');
    _isCharacterGroundedNative =
        dylib.lookupFunction<_CharacterBoolC, _CharacterBoolDart>('rapier_character_controller_is_grounded');
    _isCharacterOnWallNative =
        dylib.lookupFunction<_CharacterBoolC, _CharacterBoolDart>('rapier_character_controller_is_on_wall');
    _isCharacterOnCeilingNative =
        dylib.lookupFunction<_CharacterBoolC, _CharacterBoolDart>('rapier_character_controller_is_on_ceiling');
  }

  int createCharacterController(double offset) => _createCharacterControllerNative(offset).address;

  void destroyCharacterController(int ctrl) => _destroyCharacterControllerNative(Pointer<Void>.fromAddress(ctrl));

  void setCharacterControllerUp(int ctrl, double x, double y, double z) =>
      _setCharacterControllerUpNative(Pointer<Void>.fromAddress(ctrl), x, y, z);

  void setCharacterControllerMaxSlope(int ctrl, double angleRadians) =>
      _setCharacterControllerMaxSlopeNative(Pointer<Void>.fromAddress(ctrl), angleRadians);

  void setCharacterControllerMinSlope(int ctrl, double angleRadians) =>
      _setCharacterControllerMinSlopeNative(Pointer<Void>.fromAddress(ctrl), angleRadians);

  void setCharacterControllerSnapToGround(int ctrl, double distance, bool enabled) =>
      _setCharacterControllerSnapNative(Pointer<Void>.fromAddress(ctrl), distance, enabled);

  void setCharacterControllerAutoStep(int ctrl, double maxHeight, double minWidth, bool includeDynamicBodies) =>
      _setCharacterControllerAutoStepNative(Pointer<Void>.fromAddress(ctrl), maxHeight, minWidth, includeDynamicBodies);

  Vector3 moveCharacter(int world, int ctrl, int colliderHandle, double dx, double dy, double dz, double dt) {
    final result = _moveCharacterNative(
      Pointer<Void>.fromAddress(world),
      Pointer<Void>.fromAddress(ctrl),
      colliderHandle,
      dx,
      dy,
      dz,
      dt,
    );
    return Vector3(result.x, result.y, result.z);
  }

  bool isCharacterGrounded(int ctrl) => _isCharacterGroundedNative(Pointer<Void>.fromAddress(ctrl));

  bool isCharacterOnWall(int ctrl) => _isCharacterOnWallNative(Pointer<Void>.fromAddress(ctrl));

  bool isCharacterOnCeiling(int ctrl) => _isCharacterOnCeilingNative(Pointer<Void>.fromAddress(ctrl));
}
