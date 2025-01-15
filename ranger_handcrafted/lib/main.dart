//Modified Example from https://www.reddit.com/r/dartlang/comments/69luui/minimal_flutter_game_loop/

import 'dart:math' as math;

import 'package:flutter/material.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MyPage(),
    );
  }
}

class MyGame extends CustomPainter {
  final World world;
  final double x;
  final double y;
  final double t;

  MyGame(this.world, this.x, this.y, this.t, Animation<double> animation)
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    world.input(200, 200);
    world.update(t);
    world.render(t, canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _MyPage extends StatefulWidget {
  const _MyPage();

  @override
  _MyPageState createState() => _MyPageState();
}

class World {
  double _turn = 0.0;
  double _x;
  double _y;
  final Paint bgColor = Paint()..color = Colors.black54;
  final Paint blockColor = Paint()..color = Colors.white;
  final double size = 200.0;
  final double tau = math.pi * 2;
  final double rotationsPerSecond = 0.55;

  World(this._x, this._y);

  void input(double x, double y) {
    _x = x;
    _y = y;
  }

  void render(double t, Canvas canvas) {
    canvas.drawPaint(bgColor);
    canvas.save();
    canvas.translate(_x, _y);
    canvas.rotate(tau * _turn);
    canvas.drawRect(
      Rect.fromLTWH(
        -size / 2,
        -size / 2,
        size,
        size,
      ),
      blockColor,
    );
    canvas.restore();
  }

  void update(double t) {
    _turn += t * rotationsPerSecond;
  }
}

class _MyPageState extends State<_MyPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  World world = World(0.0, 0.0);
  final DateTime _initialTime = DateTime.now();
  double previous = 0.0;
  double pointerx = 0.0;
  double pointery = 0.0;
  double get currentTime =>
      DateTime.now().difference(_initialTime).inMilliseconds / 1000.0;

  @override
  Widget build(BuildContext context) {
    var curr = currentTime;
    var dt = curr - previous;
    previous = curr;

    return Scaffold(
      body: CustomPaint(
        painter: MyGame(world, pointerx, pointery, dt, _animation),
      ),
    );
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
