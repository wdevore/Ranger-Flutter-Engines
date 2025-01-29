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
      e.world.begin();
    } on WorldException catch (exp) {
      e.lastException = exp.message;
      stdout.write('${e.lastException}\n');
    }

    return e;
  }

  void configure() {
    world.sceneGraph.configure();
  }

  /// [boot] is called after create() and as the last thing the engine
  /// does to start the game.
  @override
  void boot() {
    running = EngineState.running;

    var scenegraph = world.sceneGraph;

    scenegraph.enter();
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

  @override
  void update(double dt) {
    world.sceneGraph.update(dt, 0.0);
  }

  @override
  void render(Canvas canvas) {
    // Once the last scene has exited the stage we stop running.
    try {
      bool moreScenes = world.sceneGraph.visit(0.0, canvas);
      if (!moreScenes) {
        running = EngineState.exited;
      }
    } on NodeException catch (e) {
      running = EngineState.halted;
      debugPrint('$e');
    }
  }
}
