part of 'rapier_bindings_impl.dart';

/// Shared base mixin for all Rapier FFI binding mixins.
///
/// Holds the loaded [DynamicLibrary] so that each domain-specific mixin
/// (World, RigidBody, Collider, Joint, CharacterController, SceneQuery)
/// can look up its own native symbols against the same library instance
/// during [RapierBindingsImpl.init].
mixin FfiBindingsBase {
  late DynamicLibrary dylib;
}
