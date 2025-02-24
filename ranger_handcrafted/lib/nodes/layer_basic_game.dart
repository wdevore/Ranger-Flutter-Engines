import 'package:ranger_core/ranger_core.dart' as core;

import 'my_square_node.dart';

class LayerBasicGame extends core.Node {
  late MySquareNode squareNode;

  LayerBasicGame();

  factory LayerBasicGame.create(
      String name, core.WorldCore world, core.Node parent) {
    LayerBasicGame layer = LayerBasicGame()
      ..initialize(name)
      ..parent = parent;

    parent.children.addLast(layer);
    layer.build(world);

    return layer;
  }

  void build(core.WorldCore world) {
    // Add nodes
    squareNode = MySquareNode.create('Square', world, this);
    squareNode.setPosition(300.0, 300.0);
    squareNode.setRotation(45.0 * core.degreesToRadians);
    squareNode.setScale(100.0);
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(core.NodeSignal signal) {
    print('LayerBasicGame.receiveSignal $signal');
  }

  @override
  void event(core.Event event) {
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
