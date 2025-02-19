import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum EngineState {
  running,
  halted,
  exited,
}

abstract class EngineCore {
  String? lastException;
  EngineState state = EngineState.halted;

  // ------- DEBUG -----------
  bool runOneLoop = false;

  void boot(String nodeName);
  void update(double dt);
  void render(Canvas canvas, Size size);

  void inputMouseMove(PointerHoverEvent event);
  void inputPanDown(DragDownDetails details);
  void inputPanUpdate(DragUpdateDetails details);
}
