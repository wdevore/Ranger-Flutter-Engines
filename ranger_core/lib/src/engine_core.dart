import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum EngineState {
  running,
  halted,
  exited,
}

abstract class EngineCore {
  String? lastException;
  EngineState running = EngineState.halted;

  // ------- DEBUG -----------
  bool runOneLoop = false;

  void update(double dt);
  void render(double dt, Canvas canvas);

  void inputMouseMove(PointerHoverEvent event);
  void inputPanDown(DragDownDetails details);
  void inputPanUpdate(DragUpdateDetails details);
}
