part of 'rapier_bindings_impl.dart';

// ==========================================
// Native (C) Signatures
// ==========================================
typedef _CreateWorldC = Pointer<Void> Function();
typedef _DestroyWorldC = Void Function(Pointer<Void>);
typedef _SetGravityC = Void Function(Pointer<Void>, Float, Float, Float);
typedef _StepWorldC = Void Function(Pointer<Void>);
typedef _GetTimestepC = Float Function(Pointer<Void>);
typedef _SetTimestepC = Void Function(Pointer<Void>, Float);

// ==========================================
// Dart Signatures
// ==========================================
typedef _CreateWorldDart = Pointer<Void> Function();
typedef _DestroyWorldDart = void Function(Pointer<Void>);
typedef _SetGravityDart = void Function(Pointer<Void>, double, double, double);
typedef _StepWorldDart = void Function(Pointer<Void>);
typedef _GetTimestepDart = double Function(Pointer<Void>);
typedef _SetTimestepDart = void Function(Pointer<Void>, double);

/// FFI bindings for the Rapier `World`: creation/destruction, gravity,
/// stepping the simulation, and timestep configuration.
mixin WorldBindings on FfiBindingsBase {
  late _CreateWorldDart _createWorldNative;
  late _DestroyWorldDart _destroyWorldNative;
  late _SetGravityDart _setGravityNative;
  late _StepWorldDart _stepWorldNative;
  late _GetTimestepDart _getTimestepNative;
  late _SetTimestepDart _setTimestepNative;

  void initWorldBindings() {
    _createWorldNative = dylib.lookupFunction<_CreateWorldC, _CreateWorldDart>('rapier_world_create');
    _destroyWorldNative = dylib.lookupFunction<_DestroyWorldC, _DestroyWorldDart>('rapier_world_destroy');
    _setGravityNative = dylib.lookupFunction<_SetGravityC, _SetGravityDart>('rapier_world_set_gravity');
    _stepWorldNative = dylib.lookupFunction<_StepWorldC, _StepWorldDart>('rapier_world_step');
    _getTimestepNative = dylib.lookupFunction<_GetTimestepC, _GetTimestepDart>('rapier_world_get_timestep');
    _setTimestepNative = dylib.lookupFunction<_SetTimestepC, _SetTimestepDart>('rapier_world_set_timestep');
  }

  int createWorld() => _createWorldNative().address;

  void setGravity(int world, double x, double y, double z) =>
      _setGravityNative(Pointer<Void>.fromAddress(world), x, y, z);

  void destroyWorld(int world) => _destroyWorldNative(Pointer<Void>.fromAddress(world));

  void stepWorld(int world) => _stepWorldNative(Pointer<Void>.fromAddress(world));

  double getTimestep(int world) => _getTimestepNative(Pointer<Void>.fromAddress(world));

  void setTimestep(int world, double dt) => _setTimestepNative(Pointer<Void>.fromAddress(world), dt);
}
