import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ranger_core/ranger_core.dart';

import 'world.dart';

class Engine extends EngineCore {
  late World world;

  Engine();

  factory Engine.create(String relativePath, String overrides) {
    Engine e = Engine()..world = World.create(relativePath);

    // Set background clear color

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

    state = EngineState.running;
  }

  void end() {
    world.end();
  }

  @override
  void inputMouseMove(PointerHoverEvent event) {}
  @override
  void inputPanDown(DragDownDetails details) {}
  @override
  void inputPanUpdate(DragUpdateDetails details) {}

  /// Called by GamePainter.
  @override
  void update(double dt) {
    world.nodeManager.update(dt, 0.0);
  }

  @override
  void render(Canvas canvas) {
    try {
      world.nodeManager.visit(0.0, canvas);
    } on NodeException catch (e) {
      state = EngineState.halted;
      debugPrint('$e');
    }
  }
}
