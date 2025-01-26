import 'package:ranger_core/src/graph/node.dart';
import 'package:ranger_core/src/graph/scene.dart';

import 'layer_basic_game.dart';
import 'world.dart';

class SceneBasicSplash extends Node {
  SceneBasicSplash();

  factory SceneBasicSplash.create(String name, World world) {
    SceneBasicSplash scene = SceneBasicSplash()
      ..initialize(name)
      ..build(world)
      ..initializeScene(SceneStates.sceneOffStage, SceneStates.sceneOffStage);
    return scene;
  }

  void build(World world) {
    LayerBasicGame.create('Game Layer', world, this);
  }
}
