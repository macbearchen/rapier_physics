import 'package:vector_math/vector_math.dart';
import 'package:rapier_physics/rapier_physics.dart';
import 'package:flutter/foundation.dart';

final world = RapierWorld();

// init rapier physics
Future<void> initPhysics() async {
  final gravity = Vector3(0, 0, -9.8);
  await world.init(gravity: gravity);
  debugPrint('Rapier World Version: ${world.version}');
}
