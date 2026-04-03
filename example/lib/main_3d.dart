import 'package:flutter/material.dart' hide Colors, Matrix4;

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
import 'physics_scene.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  M3AppEngine.instance.onDidInit = onDidInit;
  await initPhysics();

  runApp(const MyApp());
}

Future<void> onDidInit() async {
  debugPrint('main.dart: onDidInit');
  final appEngine = M3AppEngine.instance;
  appEngine.renderEngine.createShadowMap(width: 1024, height: 1024);

  await appEngine.setScene(PhysicsScene());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Rapier 3D Example')),
        body: const M3View(),
      ),
    );
  }
}
