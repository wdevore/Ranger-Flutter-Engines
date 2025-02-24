import 'package:ranger_core/src/extras/events/event.dart';
import 'package:ranger_core/src/graph/node.dart';
import 'package:ranger_core/src/world_core.dart';

import 'layer_basic_game.dart';

class NodeBasicSplash extends Node {
  NodeBasicSplash();

  factory NodeBasicSplash.create(String name, WorldCore world) {
    NodeBasicSplash scene = NodeBasicSplash()
      ..initialize(name)
      ..build(world);
    return scene;
  }

  void build(WorldCore world) {
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
  void event(Event event) {
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
