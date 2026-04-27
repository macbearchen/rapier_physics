import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rapier_physics/rapier_physics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final world = RapierWorld();
  await world.init(gravity: Vector3(0, 0, -9.8));
  print('Rapier World Version: ${world.version}');

  // Create a static floor at y = 0
  world.addBox(hx: 10.0, hy: 0.1, hz: 10.0, desc: RigidBodyDesc.fixed()..position = Vector3(0, 0, 0));

  // Create a dynamic box at y = 10.0
  final box = world.addBox(hx: 0.5, hy: 0.5, hz: 0.5, desc: RigidBodyDesc.dynamic()..position = Vector3(0, 10, 0));

  // Create a dynamic sphere at y = 15.0
  final sphere = world.addSphere(radius: 0.5, desc: RigidBodyDesc.dynamic()..position = Vector3(0, 15, 0));

  // Test setting position: Move the sphere even higher
  sphere.setPosition(Vector3(0, 30, 0));

  // Create a dynamic cylinder at y = 20.0
  final cylinder = world.addCylinder(halfHeight: 1.0, radius: 0.5, desc: RigidBodyDesc.dynamic()..position = Vector3(0, 20, 0));

  // Create a dynamic capsule at y = 25.0
  final capsule = world.addCapsule(halfHeight: 1.0, radius: 0.5, desc: RigidBodyDesc.dynamic()..position = Vector3(0, 25, 0));

  print('Initial box Y: ${box.position.y}');
  print('Initial sphere Y: ${sphere.position.y}');
  print('Initial cylinder Y: ${cylinder.position.y}');
  print('Initial capsule Y: ${capsule.position.y}');

  // Step the simulation 200 times
  for (int i = 0; i < 200; i++) {
    world.step();
    if (i % 20 == 0) {
      print(
        'Step $i, Box Y: ${box.position.y.toStringAsFixed(2)}, Sphere Y: ${sphere.position.y.toStringAsFixed(2)}, Cylinder Y: ${cylinder.position.y.toStringAsFixed(2)}, Capsule Y: ${capsule.position.y.toStringAsFixed(2)}',
      );
    }
  }

  print('Final box Y: ${box.position.y}');
  print('Final sphere Y: ${sphere.position.y}');
  print('Final cylinder Y: ${cylinder.position.y}');
  print('Final capsule Y: ${capsule.position.y}');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _rapierPhysicsPlugin = RapierPhysics();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _rapierPhysicsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Rapier Physics plugin app')),
        body: Center(child: Text('Running on: $_platformVersion\n')),
      ),
    );
  }
}
