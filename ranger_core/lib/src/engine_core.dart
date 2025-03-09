import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'world_core.dart';

enum EngineState {
  /// The game should construct itself in this state.
  constructing,

  /// In this state the game should stablize so that timing is stable.
  stabilizing,

  /// This is now running
  running,

  /// The game halted immediately. Not good.
  halted,

  /// The game exited gracefully.
  exited,
}

abstract class EngineCore {
  late WorldCore world;
  String? lastException;
  EngineState state = EngineState.halted;

  // ------- DEBUG -----------
  bool runOneLoop = false;

  void boot(String nodeName);

  /// This is where the game is constructed/built
  void construct();
  void update(double dt);
  void render(Canvas canvas, Size size);

  void inputMouseMove(PointerHoverEvent event);
  void inputPanStart(DragStartDetails details) {}
  void inputPanEnd(DragEndDetails details) {}
  void inputPanDown(DragDownDetails details) {}
  void inputPanUpdate(DragUpdateDetails details) {}

  void inputPointerSignal(PointerSignalEvent event) {}

  void inputKeyEvent(KeyEvent event) {}
}
