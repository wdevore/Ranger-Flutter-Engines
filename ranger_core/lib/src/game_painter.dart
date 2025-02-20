import 'package:flutter/material.dart';

import 'engine_core.dart';

/// Canvas's device coordinate space is:
///
///       Top-Left
///        (0,0)
///          .--------> +X
///          |
///          |
///          |
///          v         Bottom-Right
///         +Y
///     Lower-Left
///
class GamePainter extends CustomPainter {
  final EngineCore engine;
  bool running = true;

  final Animation<double> animation;
  final AnimationController _controller;

  final DateTime _initialTime = DateTime.now();
  double previous = 0.0;

  /// View base background color. The default is the Theme color.
  Paint baseBackgroundColor = Paint()..color = Colors.black54;

  /// When [animation] notifies listeners this custom painter will repaint.
  GamePainter(this.engine, this.animation, this._controller)
      : super(repaint: animation) {
    engine.state = EngineState.running;
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

    canvas.drawPaint(baseBackgroundColor);

    if (!engine.runOneLoop) {
      if (engine.state == EngineState.running) {
        engine.update(dt); // Update is independent of visibility
        engine.render(canvas, size);
      } else {
        running = false;
        if (engine.state == EngineState.halted) {
          canvas.drawPaint(Paint()..color = Colors.deepOrange);
        } else if (engine.state == EngineState.exited) {
          canvas.drawPaint(Paint()..color = Colors.brown);
        }
        _controller.stop();
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
