import 'package:ranger_handcrafted/graph/node.dart';
import 'package:ranger_handcrafted/graph/scene.dart';
import 'package:ranger_handcrafted/world.dart';

import 'layer_basic_game.dart';

class SceneBasicSplash extends Node {
  SceneBasicSplash();

  factory SceneBasicSplash.create(String name, World world) {
    SceneBasicSplash scene = SceneBasicSplash()
      ..world = world
      ..initialize(name)
      ..build(world)
      ..initializeScene(SceneStates.sceneOffStage, SceneStates.sceneOffStage);
    return scene;
  }

  void build(World world) {
    LayerBasicGame.create('Game Layer', world, this);
  }
}
