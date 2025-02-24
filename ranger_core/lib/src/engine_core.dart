import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'world_core.dart';

enum EngineState {
  constructing,
  stabilizing,
  running,
  halted,
  exited,
}

abstract class EngineCore {
  late WorldCore world;
  String? lastException;
  EngineState state = EngineState.halted;

  // ------- DEBUG -----------
  bool runOneLoop = false;

  void boot(String nodeName);
  void construct();
  void update(double dt);
  void render(Canvas canvas, Size size);

  void inputMouseMove(PointerHoverEvent event);
  void inputPanDown(DragDownDetails details);
  void inputPanUpdate(DragUpdateDetails details);
}
