import 'package:ranger_core/ranger_core.dart' as core;

import 'my_square_node.dart';
import 'tri_ship_node.dart';

class LayerBasicGame extends core.Node {
  late MySquareNode squareNode;
  late TriShipNode shipNode;

  late core.WorldCore world;

  late core.ZoomNode zoomNode;

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
    zoomNode = core.ZoomNode.create('Zoom', world, this);

    // Add nodes
    squareNode = MySquareNode.create('Square', 45.0, world, zoomNode)
      ..setPosition(300.0, 200.0)
      ..setScale(100.0);

    shipNode = TriShipNode.create('Ship', 45.0, world, zoomNode)
      ..setPosition(400.0, 400.0)
      ..setScale(30.0);
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
  void event(core.Event event, double dt) {}
}
