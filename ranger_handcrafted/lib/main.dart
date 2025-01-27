import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart';

import 'engine.dart';
import 'nodes/scene_basic_splash.dart';
import 'world.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _GamePage(),
    );
  }
}

class _GamePage extends StatefulWidget {
  const _GamePage();

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<_GamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Engine engine;

  _GamePageState() {
    engine = Engine.create('relativePath', 'overrides');
    World world = engine.world;

    SceneBasicSplash splash = SceneBasicSplash.create('Splash', world);
    world.push(splash);

    // Last scene pushed is the first to run.
    SceneBasicBoot boot = SceneBasicBoot.create('Boot');
    world.push(boot);

    engine.begin();
  }

  final DateTime _initialTime = DateTime.now();

  double previous = 0.0;

  double get currentTime =>
      DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;

  @override
  Widget build(BuildContext context) {
    double curr = currentTime;
    double dt = curr - previous;
    previous = curr;

    return Scaffold(
      body: MouseRegion(
        onHover: (event) => engine.inputMouseMove(event),
        child: GestureDetector(
          onPanDown: (details) => engine.inputPanDown(details),
          onPanUpdate: (details) => engine.inputPanUpdate(details),
          child: CustomPaint(
            painter: GamePainter(engine, dt, _animation, _controller),
            child: _buildErrorExceptionOverlay(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorExceptionOverlay() {
    switch (engine.running) {
      case EngineState.exited:
        return Center(child: Text('Engine Exited'));
      case EngineState.halted:
        return Center(child: Text('Engine halted'));
      default:
        return SizedBox.expand(); // Be as big as possible
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    previous = currentTime;

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat();
  }
}

// class World {
//   double _turn = 0.0;
//   double _x;
//   double _y;
//   final Paint bgColor = Paint()..color = Colors.black54;
//   final Paint blockColor = Paint()..color = Colors.orange;
//   final double size = 200.0;
//   final double tau = math.pi * 2;
//   final double rotationsPerSecond = 0.55;

//   World(this._x, this._y);

//   void input(double x, double y) {
//     _x = x;
//     _y = y;
//   }

//   void render(double t, Canvas canvas) {
//     canvas.drawPaint(bgColor);

//     canvas.save();

//     canvas.translate(_x, _y);
//     canvas.rotate(tau * _turn);

//     canvas.drawRect(
//       Rect.fromLTWH(
//         -size / 2,
//         -size / 2,
//         size,
//         size,
//       ),
//       blockColor,
//     );

//     canvas.restore();
//   }

//   void update(double t) {
//     _turn += t * rotationsPerSecond;
//   }
// }
