import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';
import '../rigid_body_type.dart';
import 'rapier_bindings.dart';

// Native (C) signatures
typedef _CreateWorldC = Pointer<Void> Function();
typedef _VersionC = Pointer<Utf8> Function();
typedef _StepWorldC = Void Function(Pointer<Void>);
typedef _CreateRigidBodyC = Uint32 Function(Pointer<Void>, Float, Float, Float, Uint8);
typedef _CreateBoxColliderC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _CreateSphereColliderC = Void Function(Pointer<Void>, Uint32, Float);
typedef _CreateCylinderColliderC = Void Function(Pointer<Void>, Uint32, Float, Float);
typedef _CreateCapsuleColliderC = Void Function(Pointer<Void>, Uint32, Float, Float);
typedef _GetFloatC = Float Function(Pointer<Void>, Uint32);
typedef _SetPositionC = Void Function(Pointer<Void>, Uint32, Float, Float, Float);
typedef _SetRotationC = Void Function(Pointer<Void>, Uint32, Float, Float, Float, Float);
typedef _SetGravityC = Void Function(Pointer<Void>, Float, Float, Float);

// Dart-side equivalents
typedef _CreateWorldDart = Pointer<Void> Function();
typedef _VersionDart = Pointer<Utf8> Function();
typedef _StepWorldDart = void Function(Pointer<Void>);
typedef _CreateRigidBodyDart = int Function(Pointer<Void>, double, double, double, int);
typedef _CreateBoxColliderDart = void Function(Pointer<Void>, int, double, double, double);
typedef _CreateSphereColliderDart = void Function(Pointer<Void>, int, double);
typedef _CreateCylinderColliderDart = void Function(Pointer<Void>, int, double, double);
typedef _CreateCapsuleColliderDart = void Function(Pointer<Void>, int, double, double);
typedef _GetFloatDart = double Function(Pointer<Void>, int);
typedef _SetPositionDart = void Function(Pointer<Void>, int, double, double, double);
typedef _SetRotationDart = void Function(Pointer<Void>, int, double, double, double, double);
typedef _SetGravityDart = void Function(Pointer<Void>, double, double, double);

class RapierBindingsImpl extends RapierBindings {
  late DynamicLibrary _dylib;

  late _VersionDart _versionNative;
  late _CreateWorldDart _createWorldNative;
  late _SetGravityDart _setGravityNative;
  late _StepWorldDart _stepWorldNative;
  late _CreateRigidBodyDart _createRigidBodyNative;
  late _CreateBoxColliderDart _createBoxColliderNative;
  late _CreateSphereColliderDart _createSphereColliderNative;
  late _CreateCylinderColliderDart _createCylinderColliderNative;
  late _CreateCapsuleColliderDart _createCapsuleColliderNative;
  
  late _GetFloatDart _getPosX;
  late _GetFloatDart _getPosY;
  late _GetFloatDart _getPosZ;
  late _GetFloatDart _getRotX;
  late _GetFloatDart _getRotY;
  late _GetFloatDart _getRotZ;
  late _GetFloatDart _getRotW;

  late _SetPositionDart _setPositionNative;
  late _SetRotationDart _setRotationNative;

  @override
  Future<void> init() async {
    if (Platform.isMacOS || Platform.isIOS) {
      _dylib = DynamicLibrary.process();
    } else if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('prebuilt/rapier_ffi.dll');
    } else if (Platform.isLinux) {
      _dylib = DynamicLibrary.open('prebuilt/librapier_ffi.so');
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('librapier_ffi.so');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    _versionNative = _dylib.lookupFunction<_VersionC, _VersionDart>('rapier_version');
    _createWorldNative = _dylib.lookupFunction<_CreateWorldC, _CreateWorldDart>('rapier_world_create');
    _setGravityNative = _dylib.lookupFunction<_SetGravityC, _SetGravityDart>('rapier_world_set_gravity');
    _stepWorldNative = _dylib.lookupFunction<_StepWorldC, _StepWorldDart>('rapier_world_step');
    _createRigidBodyNative = _dylib.lookupFunction<_CreateRigidBodyC, _CreateRigidBodyDart>('rapier_create_rigid_body');
    _createBoxColliderNative = _dylib.lookupFunction<_CreateBoxColliderC, _CreateBoxColliderDart>('rapier_create_box_collider');
    _createSphereColliderNative = _dylib.lookupFunction<_CreateSphereColliderC, _CreateSphereColliderDart>('rapier_create_sphere_collider');
    _createCylinderColliderNative = _dylib.lookupFunction<_CreateCylinderColliderC, _CreateCylinderColliderDart>('rapier_create_cylinder_collider');
    _createCapsuleColliderNative = _dylib.lookupFunction<_CreateCapsuleColliderC, _CreateCapsuleColliderDart>('rapier_create_capsule_collider');

    _getPosX = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_position_x');
    _getPosY = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_position_y');
    _getPosZ = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_position_z');
    _getRotX = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_x');
    _getRotY = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_y');
    _getRotZ = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_z');
    _getRotW = _dylib.lookupFunction<_GetFloatC, _GetFloatDart>('rapier_get_body_rotation_w');

    _setPositionNative = _dylib.lookupFunction<_SetPositionC, _SetPositionDart>('rapier_set_body_position');
    _setRotationNative = _dylib.lookupFunction<_SetRotationC, _SetRotationDart>('rapier_set_body_rotation');
  }

  @override
  String getVersion() => _versionNative().toDartString();

  @override
  int createWorld() => _createWorldNative().address;

  @override
  void setGravity(int world, double x, double y, double z) =>
      _setGravityNative(Pointer<Void>.fromAddress(world), x, y, z);

  @override
  void stepWorld(int world) => _stepWorldNative(Pointer<Void>.fromAddress(world));

  @override
  int createRigidBody(int world, double x, double y, double z, RigidBodyType type) =>
      _createRigidBodyNative(Pointer<Void>.fromAddress(world), x, y, z, type.index);

  @override
  void createBoxCollider(int world, int body, double hx, double hy, double hz) =>
      _createBoxColliderNative(Pointer<Void>.fromAddress(world), body, hx, hy, hz);

  @override
  void createSphereCollider(int world, int body, double radius) =>
      _createSphereColliderNative(Pointer<Void>.fromAddress(world), body, radius);

  @override
  void createCylinderCollider(int world, int body, double halfHeight, double radius) =>
      _createCylinderColliderNative(Pointer<Void>.fromAddress(world), body, halfHeight, radius);

  @override
  void createCapsuleCollider(int world, int body, double halfHeight, double radius) =>
      _createCapsuleColliderNative(Pointer<Void>.fromAddress(world), body, halfHeight, radius);

  @override
  Vector3 getBodyPosition(int world, int body) {
    final handle = Pointer<Void>.fromAddress(world);
    return Vector3(
      _getPosX(handle, body),
      _getPosY(handle, body),
      _getPosZ(handle, body),
    );
  }

  @override
  Quaternion getBodyRotation(int world, int body) {
    final handle = Pointer<Void>.fromAddress(world);
    return Quaternion(
      _getRotX(handle, body),
      _getRotY(handle, body),
      _getRotZ(handle, body),
      _getRotW(handle, body),
    );
  }

  @override
  void setBodyPosition(int world, int body, double x, double y, double z) =>
      _setPositionNative(Pointer<Void>.fromAddress(world), body, x, y, z);

  @override
  void setBodyRotation(int world, int body, double x, double y, double z, double w) =>
      _setRotationNative(Pointer<Void>.fromAddress(world), body, x, y, z, w);
}
