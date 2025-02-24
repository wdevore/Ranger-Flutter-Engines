import 'package:ranger_core/ranger_core.dart' as core;

import 'my_square_node.dart';

class LayerBasicGame extends core.Node {
  late MySquareNode squareNode;
  late core.WorldCore world;
  late core.StaticTextNode textNode;

  LayerBasicGame();

  factory LayerBasicGame.create(
      String name, core.WorldCore world, core.Node parent) {
    LayerBasicGame layer = LayerBasicGame()
      ..initialize(name)
      ..world = world
      ..nodeMan = world.nodeManager
      ..parent = parent;

    parent.children.addLast(layer);
    layer.build(world);

    return layer;
  }

  void build(core.WorldCore world) {
    // Add nodes
    squareNode = MySquareNode.create('Square', 45.0, world, this);
    squareNode.setPosition(300.0, 200.0);
    squareNode.setScale(100.0);

    double scale = 15.0;
    textNode =
        core.StaticTextNode.create('ABBa', world, this, charSpacing: 0.5);
    textNode.setPosition(scale, world.deviceSize.height - scale);
    textNode.setScale(scale);
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(core.NodeSignal signal) {
    print('LayerBasicGame.receiveSignal $signal');
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------
  @override
  void event(core.Event event) {}
}
