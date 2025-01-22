import 'dart:io';

import 'graph/node_manager.dart';

import 'world.dart';

class Engine {
  late World world;

  String? lastException;
  bool running = false;

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
    world.sceneGraph.configure(world);
  }

  /// [begin] is called after create() and as the last thing the engine
  /// does to start the game.
  void begin() {
    running = true;

    var scenegraph = world.sceneGraph;

    try {
      scenegraph.begin();
      loop(scenegraph);
    } on NodeException catch (e) {
      lastException = e.message;
      stdout.write('$lastException\n');
    }
  }

  void loop(NodeManager scenegraph) {
    var interpolation = 0.0;

    while (running) {
      scenegraph.update(0.0, 0.0);

      // Once the last scene has exited the stage we stop running.
      bool moreScenes = scenegraph.visit(interpolation);

      if (!moreScenes || runOneLoop) {
        running = false;
        continue;
      }
    }
  }

  void end() {
    world.end();
  }
}
