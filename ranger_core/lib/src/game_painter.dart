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
      : super(repaint: animation);

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
      switch (engine.state) {
        case EngineState.running:
          engine.update(dt); // Update is independent of visibility
          engine.render(canvas, size);
          break;
        case EngineState.constructing:
          engine.world.deviceSize = size;
          // Engine can now construct the game.
          engine.construct();
          engine.state = EngineState.stabilizing;
          break;
        case EngineState.stabilizing:
          engine.state = EngineState.running;
          break;
        case EngineState.halted:
          canvas.drawPaint(Paint()..color = Colors.deepOrange);
          _controller.stop();
        case EngineState.exited:
          canvas.drawPaint(Paint()..color = Colors.brown);
          _controller.stop();
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
