import 'package:flutter/material.dart';

import 'package:ranger_core/ranger_core.dart';
import 'engine.dart';
import 'game_page.dart';
import 'nodes/scene_basic_splash.dart';

Engine _constructGame() {
  Engine engine = Engine.create('relativePath', 'overrides');
  WorldCore world = engine.world;

  NodeBasicSplash splash = NodeBasicSplash.create('Splash', world);
  world.nodeManager.addNode(splash);

  NodeBasicBoot boot = NodeBasicBoot.create('Boot', world.nodeManager);
  world.nodeManager.addNode(boot);

  // The run stack needs at least 1 Node
  engine.boot(boot.name);

  return engine;
}

void main() {
  final Engine engine = _constructGame();
  runApp(GameApp(engine: engine));
}
