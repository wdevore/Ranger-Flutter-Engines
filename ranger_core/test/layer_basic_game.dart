import 'package:ranger_core/src/graph/node.dart';

import 'my_square_node.dart';
import 'world.dart';

class LayerBasicGame extends Node {
  late MySquareNode squareNode;

  LayerBasicGame();

  factory LayerBasicGame.create(String name, World world, Node parent) {
    LayerBasicGame layer = LayerBasicGame()
      ..initialize(name)
      ..parent = parent;

    parent.children.addLast(layer);
    layer.build(world);

    return layer;
  }

  void build(World world) {
    // Add nodes
    squareNode = MySquareNode.create('Square', world, this);
    squareNode.setPosition(300.0, 300.0);
  }

  @override
  void event() {
    // TODO: implement event
  }

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------
  @override
  void timing(double dt) {
    // TODO: implement timing
  }
}
