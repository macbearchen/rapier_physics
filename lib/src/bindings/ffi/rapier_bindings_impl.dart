import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:vector_math/vector_math.dart';
import '../../rigid_body_desc.dart';
import '../../collider_desc.dart';
import '../rapier_bindings.dart';

part 'native_types.dart';
part 'ffi_base.dart';
part 'world_bindings.dart';
part 'rigid_body_bindings.dart';
part 'collider_bindings.dart';
part 'joint_bindings.dart';
part 'character_controller_bindings.dart';
part 'scene_query_bindings.dart';
part 'vehicle_controller_bindings.dart';

// Version query is small enough to live directly on the implementation
// class rather than in its own part file.
typedef _VersionC = Pointer<Utf8> Function();
typedef _VersionDart = Pointer<Utf8> Function();

/// Concrete FFI implementation of [RapierBindings].
///
/// Domain-specific bindings (World, RigidBody, Collider, Joint,
/// CharacterController, SceneQuery) each live in their own `part` file
/// under `bindings/ffi/` and are combined here via mixins. Because all
/// parts belong to this one library, they share a single private (`_`)
/// namespace — shared structs/typedefs live in `native_types.dart` and
/// are declared exactly once.
class RapierBindingsImpl extends RapierBindings
    with
        FfiBindingsBase,
        WorldBindings,
        RigidBodyBindings,
        ColliderBindings,
        JointBindings,
        CharacterControllerBindings,
        SceneQueryBindings,
        VehicleControllerBindings {
  late _VersionDart _versionNative;

  @override
  Future<void> init() async {
    dylib = _loadLibrary();

    _versionNative = dylib.lookupFunction<_VersionC, _VersionDart>('rapier_version');

    initWorldBindings();
    initRigidBodyBindings();
    initColliderBindings();
    initJointBindings();
    initCharacterControllerBindings();
    initSceneQueryBindings();
    initVehicleControllerBindings();
  }

  DynamicLibrary _loadLibrary() {
    if (Platform.isMacOS || Platform.isIOS) {
      return DynamicLibrary.process();
    } else if (Platform.isWindows) {
      try {
        return DynamicLibrary.open('rapier_ffi.dll');
      } catch (_) {
        return DynamicLibrary.open('prebuilt/rapier_ffi.dll');
      }
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('prebuilt/librapier_ffi.so');
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('librapier_ffi.so');
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  @override
  String getVersion() => _versionNative().toDartString();
}
