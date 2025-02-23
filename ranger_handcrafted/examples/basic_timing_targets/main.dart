import 'package:flutter/material.dart';

import 'package:ranger_core/ranger_core.dart' as core;
import 'engine.dart';
import 'game_page.dart';
import 'nodes/node_basic_splash.dart';

Engine _constructGame() {
  Engine engine = Engine.create('relativePath', 'overrides');
  core.WorldCore world = engine.world;

  NodeBasicSplash splash = NodeBasicSplash.create('Splash', world);
  // Preset Splash to replace NodeBasicBoot when boot exits.
  // Thus we add and push splash.
  world.nodeManager.addPushNode(splash);

  core.NodeBasicBoot boot =
      core.NodeBasicBoot.create('Boot', world.nodeManager);
  world.nodeManager.addNode(boot);

  // The run stack needs at least 1 Node
  engine.boot(boot.name);

  return engine;
}

void main() {
  final Engine engine = _constructGame();
  runApp(GameApp(engine: engine));
}
