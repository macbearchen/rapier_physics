// ignore_for_file: unused_import

import 'package:flutter/material.dart';

import 'demos/base_scene.dart' hide Colors;
import 'demos/physics_scene.dart';
import 'demos/compound_scene.dart';
import 'demos/double_pendulum.dart';
import 'demos/newton_cradle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  M3AppEngine.instance.onDidInit = onDidInit;

  runApp(MyApp());
}

Future<void> onDidInit() async {
  M3Log.i('main.dart', 'onDidInit');
  final appEngine = M3AppEngine.instance;
  appEngine.renderEngine.createShadowMap(width: 2048, height: 4096);

  final testScene = BaseScene.createPhysicsScene((physicsSystem) => PhysicsScene(physics: physicsSystem));
  // final testScene = BaseScene();
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
          title: Text(RapierPhysics.version),
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
                  final lightViewer = scene.dirLight.lightViewer;
                  lightViewer.target = Vector3.zero();
                  lightViewer.setViewport(-halfView, -halfView, halfView * 2, halfView * 2, fovy: 0, far: 50);
                  lightViewer.setEuler(pi / 5, -pi / 3, 0, distance: 30); // rotate light
                  lightViewer.refreshProjectionMatrix();
                } else {
                  renderOptions.shadows = true;
                  scene.camera.csmCount = 4;
                }
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

/// panel for select physics scene
class PanelWidget extends StatefulWidget {
  const PanelWidget({super.key});

  @override
  _PanelWidgetState createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  int _selectedIndex = 0;

  Future<void> _loadScene(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    M3Scene scene;
    if (index == 0) {
      scene = BaseScene.createPhysicsScene((physicsSystem) => PhysicsScene(physics: physicsSystem));
    } else if (index == 1) {
      scene = BaseScene.createPhysicsScene((physicsSystem) => NewtonCradleScene(physics: physicsSystem));
    } else if (index == 2) {
      scene = BaseScene.createPhysicsScene((physicsSystem) => DoublePendulumScene(physics: physicsSystem));
    } else {
      scene = BaseScene.createPhysicsScene((physicsSystem) => CompoundScene(physics: physicsSystem));
    }

    await M3AppEngine.instance.setScene(scene);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'scene_01',
          backgroundColor: _selectedIndex == 0 ? Colors.lightGreen : Colors.grey,
          onPressed: () => _loadScene(0),
          child: const Icon(Icons.filter_1),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: 'scene_02',
          backgroundColor: _selectedIndex == 1 ? Colors.lightGreen : Colors.grey,
          onPressed: () => _loadScene(1),
          child: const Icon(Icons.filter_2),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: 'scene_03',
          backgroundColor: _selectedIndex == 2 ? Colors.lightGreen : Colors.grey,
          onPressed: () => _loadScene(2),
          child: const Icon(Icons.filter_3),
        ),
        const SizedBox(width: 10),
        FloatingActionButton(
          heroTag: 'scene_04',
          backgroundColor: _selectedIndex == 3 ? Colors.lightGreen : Colors.grey,
          onPressed: () => _loadScene(3),
          child: const Icon(Icons.filter_4),
        ),
      ],
    );
  }
}
