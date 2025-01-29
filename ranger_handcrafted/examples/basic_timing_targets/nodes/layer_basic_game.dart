import 'package:ranger_core/ranger_core.dart' as core;

import 'my_square_node.dart';
import '../world.dart';

class LayerBasicGame extends core.Node {
  late MySquareNode squareNode;

  LayerBasicGame();

  factory LayerBasicGame.create(String name, World world, core.Node parent) {
    LayerBasicGame layer = LayerBasicGame()
      ..initialize(name)
      ..parent = parent
      ..initializeScene(
          core.SceneStates.sceneOffStage, core.SceneStates.sceneOffStage);

    parent.children.addLast(layer);
    layer.build(world);

    return layer;
  }

  void build(World world) {
    // Add nodes
    squareNode = MySquareNode.create('Square', 45.0, world, this);
    squareNode.setPosition(300.0, 200.0);
    squareNode.setScale(100.0);

    // Register to get timing update events.
    world.sceneGraph.registerTarget(squareNode);
  }

  // NOTE: you must register this Node in the build method first.
  // For example:
  // world.sceneGraph.registerTarget(this);
  @override
  void update(double msPerUpdate, double secPerUpdate) {
    // Update a node property here.

    super.update(msPerUpdate, secPerUpdate);
  }
}
