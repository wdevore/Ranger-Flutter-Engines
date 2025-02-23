import 'package:ranger_core/ranger_core.dart' as core;

import 'layer_basic_game.dart';

class NodeBasicSplash extends core.Node {
  NodeBasicSplash();

  factory NodeBasicSplash.create(String name, core.WorldCore world) {
    NodeBasicSplash scene = NodeBasicSplash()
      ..initialize(name)
      ..nodeMan = world.nodeManager
      ..build(world);
    return scene;
  }

  void build(core.WorldCore world) {
    LayerBasicGame.create('Game Layer', world, this);
  }

  // --------------------------------------------------------
  // Signals from NodeManager (NM) or other Nodes via NM
  // --------------------------------------------------------
  @override
  void receiveSignal(core.NodeSignal signal) {
    print('NodeBasicSplash.receiveSignal $signal');
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------
  @override
  void event(core.Event event) {
    // TODO: implement event
  }

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------
  @override
  void timing(double dt) {
    switch (state) {
      default:
        // Default is where most of the action takes place.
        print('default');
        break;
    }
  }
}
