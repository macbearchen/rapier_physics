import 'package:flutter_test/flutter_test.dart';
import 'package:rapier_physics/rapier_physics.dart';
import 'package:rapier_physics/rapier_physics_platform_interface.dart';
import 'package:rapier_physics/rapier_physics_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRapierPhysicsPlatform
    with MockPlatformInterfaceMixin
    implements RapierPhysicsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RapierPhysicsPlatform initialPlatform = RapierPhysicsPlatform.instance;

  test('$MethodChannelRapierPhysics is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRapierPhysics>());
  });

  test('getPlatformVersion', () async {
    RapierPhysics rapierPhysicsPlugin = RapierPhysics();
    MockRapierPhysicsPlatform fakePlatform = MockRapierPhysicsPlatform();
    RapierPhysicsPlatform.instance = fakePlatform;

    expect(await rapierPhysicsPlugin.getPlatformVersion(), '42');
  });
}
