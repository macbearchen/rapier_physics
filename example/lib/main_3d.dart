import 'dart:math';
import 'package:flutter/material.dart' hide Colors, Matrix4;
import 'package:rapier_physics/rapier_physics.dart';

// Macbear3D engine
import 'package:macbear_3d/macbear_3d.dart';
import 'demos/physics_scene.dart';
import 'panel.dart';

final world = RapierWorld();

// init rapier physics
Future<void> initPhysics() async {
  final gravity = Vector3(0, 0, -9.8);
  await world.init(gravity: gravity);
  debugPrint('Rapier World Version: ${world.version}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  M3AppEngine.instance.onDidInit = onDidInit;
  await initPhysics();

  runApp(MyApp());
}

Future<void> onDidInit() async {
  debugPrint('main.dart: onDidInit');
  final appEngine = M3AppEngine.instance;
  appEngine.renderEngine.createShadowMap(width: 2048, height: 4096);

  final testScene = PhysicsScene();
  await appEngine.setScene(testScene);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // 0 - no shadow
  // 1 - shadowmap
  // 2 - csm
  int shadowMode = 2;

  @override
  Widget build(BuildContext context) {
    final renderOptions = M3AppEngine.instance.renderEngine.options;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rapier 3D Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () async {
                renderOptions.debug.showHelpers = !renderOptions.debug.showHelpers;
              },
            ),
            IconButton(
              icon: const Icon(Icons.grid_3x3_outlined),
              onPressed: () async {
                renderOptions.debug.wireframe = !renderOptions.debug.wireframe;
              },
            ),
            IconButton(
              icon: const Icon(Icons.light_mode),
              onPressed: () async {
                final scene = M3AppEngine.instance.activeScene!;
                shadowMode = (shadowMode + 1) % 3;
                if (shadowMode == 0) {
                  renderOptions.shadows = false;
                } else if (shadowMode == 1) {
                  renderOptions.shadows = true;
                  scene.camera.csmCount = 0;
                  final halfView = 8;
                  scene.light.target = Vector3.zero();
                  scene.light.setViewport(-halfView, -halfView, halfView * 2, halfView * 2, fovy: 0, far: 50);
                  scene.light.setEuler(pi / 5, -pi / 3, 0, distance: 30); // rotate light
                  scene.light.refreshProjectionMatrix();
                } else {
                  renderOptions.shadows = true;
                  scene.camera.csmCount = 4;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                world.destroy();
                await initPhysics();
                await M3AppEngine.instance.setScene(PhysicsScene());
              },
            ),
          ],
        ),
        body: const M3View(),
        floatingActionButton: const PanelWidget(),
      ),
    );
  }
}
