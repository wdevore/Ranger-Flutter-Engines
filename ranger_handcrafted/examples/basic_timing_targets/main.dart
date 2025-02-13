import 'package:flutter/material.dart';

import 'package:ranger_core/ranger_core.dart';
import 'engine.dart';
import 'game_page.dart';
import 'nodes/node_basic_splash.dart';
import 'world.dart';

Engine _constructGame() {
  Engine engine = Engine.create('relativePath', 'overrides');
  World world = engine.world;

  NodeBasicSplash splash = NodeBasicSplash.create('Splash', world);
  // Preset Splash to replace NodeBasicBoot when boot exits.
  // Thus we add and push splash.
  world.nodeManager.addPushNode(splash);

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
