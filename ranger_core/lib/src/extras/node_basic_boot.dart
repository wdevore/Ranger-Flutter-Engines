import '../graph/node.dart';
import '../graph/node_manager.dart';

enum BootState {
  /// Node maintains its current state (i.e. running)
  maintain,
  delaying,

  /// Send signal to NodeManger
  sendSignal,
}

/// This boot Node currently does nothing. It's as plain as it gets.
class NodeBasicBoot extends Node {
  BootState customeState = BootState.maintain;

  double timeCnt = 0.0;

  NodeBasicBoot();

  factory NodeBasicBoot.create(String name, NodeManager nodeMan) =>
      NodeBasicBoot()
        ..initialize(name)
        ..nodeMan = nodeMan
        ..build();

  void build() {
    // This Scene has no Nodes. It exits immediately.
    customeState = BootState.delaying;
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(NodeSignal signal) {
    print('NodeBasicBoot.receiveSignal $signal');
  }

  // Called by NodeManager
  @override
  void event() {
    // TODO: implement event
  }

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------
  // Called by NodeManager
  @override
  void update(double dt) {
    switch (customeState) {
      case BootState.delaying:
        timeCnt += dt;
        if (timeCnt > 2000.0) {
          customeState = BootState.sendSignal;
        }
        break;
      case BootState.sendSignal:
        sendSignal(NodeSignal.requestNodeLeaveStage);
        break;
      default:

        // Boot simply exits the stage immediately. The NM will immediately
        // pop this node from the Top which inactivates it.
        // state = NodeState.waitSignal; // No need for this
        break;
    }
    // TODO: implement timing
    // sendSignal(NodeSignal.requestNodeLeaveStage);
  }
}
