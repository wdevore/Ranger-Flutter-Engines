import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ranger_core/src/exceptions.dart';
import 'package:ranger_core/src/graph/node_manager.dart';

import 'world.dart';

enum EngineState {
  running,
  halted,
  exited,
}

class Engine {
  late World world;

  String? lastException;
  EngineState running = EngineState.halted;

  // ------- DEBUG -----------
  bool runOneLoop = false;

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

  /// [begin] is called after create() and as the last thing the engine
  /// does to start the game.
  void begin() {
    running = EngineState.running;

    var scenegraph = world.sceneGraph;

    // try {
    scenegraph.begin();
    //   loop(scenegraph);
    // } on NodeException catch (e) {
    //   lastException = e.message;
    //   stdout.write('$lastException\n');
    // }
  }

  // DEPRECATED
  // void loop(NodeManager scenegraph) {
  //   var interpolation = 0.0;

  //   while (running == EngineState.running) {
  //     scenegraph.update(0.0, 0.0);

  //     // Once the last scene has exited the stage we stop running.
  //     bool moreScenes = scenegraph.visit(interpolation);

  //     if (!moreScenes || runOneLoop) {
  //       running = EngineState.halted;
  //       continue;
  //     }
  //   }
  // }

  void end() {
    world.end();
  }

  void inputMouseMove(PointerHoverEvent event) {}
  void inputPanDown(DragDownDetails details) {}
  void inputPanUpdate(DragUpdateDetails details) {}

  void update(double dt) {
    world.sceneGraph.update(dt, 0.0);
  }

  void render(double dt, Canvas canvas) {
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
