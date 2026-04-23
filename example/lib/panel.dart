import 'package:flutter/material.dart';
import 'package:macbear_3d/macbear_3d.dart';
import 'main_3d.dart';
import 'demos/physics_scene.dart';
import 'demos/newton_cradle.dart';
import 'demos/double_pendulum.dart';

class PanelWidget extends StatefulWidget {
  const PanelWidget({Key? key}) : super(key: key);

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
      scene = PhysicsScene();
    } else if (index == 1) {
      scene = NewtonCradleScene();
    } else {
      scene = DoublePendulumScene();
    }

    world.destroy();
    await initPhysics();
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
      ],
    );
  }
}
