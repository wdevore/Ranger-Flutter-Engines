import 'package:flutter/material.dart';

import 'engine_core.dart';

class GamePainter extends CustomPainter {
  final EngineCore engine;

  final double t;
  final Animation<double> animation;
  final AnimationController _controller;
  final DateTime _initialTime = DateTime.now();
  double previous = 0.0;

  /// When [animation] notifies listeners this custom painter will repaint.
  GamePainter(this.engine, this.t, this.animation, this._controller)
      : super(repaint: animation) {
    engine.running = EngineState.running;
  }

  double get currentTime => DateTime.now()
      .difference(_initialTime)
      .inMilliseconds
      .toDouble(); // / 1000.0;

  // ---------------------------------------------------------------------
  // ----------------------- GAME LOOP -----------------------------------
  // ---------------------------------------------------------------------
  @override
  void paint(Canvas canvas, Size size) {
    double curr = currentTime;
    double dt = curr - previous;
    previous = curr;

    canvas.drawPaint(Paint()..color = Colors.black87);

    // Input comes from Gesture widget
    if (engine.running == EngineState.running) {
      engine.update(dt);

      engine.render(dt, canvas);
    } else {
      if (engine.running == EngineState.halted) {
        canvas.drawPaint(Paint()..color = Colors.deepOrange);
      } else if (engine.running == EngineState.exited) {
        canvas.drawPaint(Paint()..color = Colors.brown);
      }
      _controller.stop();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
