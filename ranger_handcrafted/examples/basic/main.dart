import 'package:flutter/material.dart';

import 'package:ranger_core/ranger_core.dart';
import 'engine.dart';
import 'game_page.dart';
import 'nodes/scene_basic_splash.dart';
import 'world.dart';

Engine _constructGame() {
  Engine engine = Engine.create('relativePath', 'overrides');
  World world = engine.world;

  SceneBasicSplash splash = SceneBasicSplash.create('Splash', world);
  world.push(splash);

  // Last scene pushed is the first to run.
  SceneBasicBoot boot = SceneBasicBoot.create('Boot');
  world.push(boot);

  engine.boot();

  return engine;
}

void main() {
  final Engine engine = _constructGame();
  runApp(GameApp(engine: engine));
}
