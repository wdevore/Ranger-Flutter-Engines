import 'package:ranger_handcrafted/graph/node.dart';
import 'package:ranger_handcrafted/graph/scene.dart';
import 'package:ranger_handcrafted/world.dart';

class LayerBasicGame extends Node {
  LayerBasicGame();

  factory LayerBasicGame.create(String name, World world, Node parent) {
    LayerBasicGame layer = LayerBasicGame()
      ..world = world
      ..initialize(name)
      ..parent = parent
      ..initializeScene(SceneStates.sceneOffStage, SceneStates.sceneOffStage);

    parent.children.addLast(layer);
    layer.build(world);

    return layer;
  }

  void build(World world) {
    // Add nodes
  }
}
