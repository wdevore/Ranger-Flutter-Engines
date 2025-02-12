import 'package:ranger_core/src/graph/node.dart';

import 'layer_basic_game.dart';
import 'world.dart';

class NodeBasicSplash extends Node {
  NodeBasicSplash();

  factory NodeBasicSplash.create(String name, World world) {
    NodeBasicSplash scene = NodeBasicSplash()
      ..initialize(name)
      ..build(world);
    return scene;
  }

  void build(World world) {
    LayerBasicGame.create('Game Layer', world, this);
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(NodeSignal signal) {
    print('NodeBasicSplash.receiveSignal $signal');
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------
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
