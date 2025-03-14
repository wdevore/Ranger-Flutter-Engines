import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ranger_core/src/engine_core.dart';
import 'package:ranger_core/src/exceptions.dart';

import 'world.dart';

class Engine extends EngineCore {
  Engine();

  factory Engine.create(String relativePath, String overrides) {
    Engine e = Engine()
      ..world = World.create(relativePath)
      ..state = EngineState.constructing;

    try {
      e.configure();
      e.world.construct();
    } on WorldException catch (exp) {
      e.lastException = exp.message;
      stdout.write('${e.lastException}\n');
    }

    return e;
  }

  void configure() {
    world.nodeManager.configure();
  }

  /// [boot] is called after create() and as the last thing the engine
  /// does to start the game.
  @override
  void boot(String nodeName) {
    world.nodeManager.pushNode(nodeName);
  }

  void end() {
    world.end();
  }

  @override
  void update(double dt) {
    world.nodeManager.update(dt, 0.0);
  }

  // --------------------------------------------------------------------
  // IO events
  // --------------------------------------------------------------------
  @override
  void inputMouseMove(PointerHoverEvent event) {}
  @override
  void inputPanDown(DragDownDetails details) {}
  @override
  void inputPanUpdate(DragUpdateDetails details) {}

  @override
  void render(Canvas canvas, Size size) {
    // Once the last scene has exited the stage we stop running.
    try {
      world.nodeManager.visit(0.0, canvas, size);
    } on NodeException catch (e) {
      state = EngineState.halted;
      debugPrint('$e');
    }
  }

  @override
  void construct() {
    // TODO: implement construct
  }
}
