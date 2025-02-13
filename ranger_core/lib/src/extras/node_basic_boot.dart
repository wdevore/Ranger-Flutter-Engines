import 'package:flutter/material.dart';

import 'package:ranger_core/ranger_core.dart' as core;
import '../graph/node.dart';
import '../graph/node_manager.dart';
import 'misc/delay.dart';

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
  Paint baseBackgroundColor = Paint()..color = Colors.indigo;

  Delay delay = Delay.create(1000.0);

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

  @override
  void render(core.Matrix4 model, Canvas canvas) {
    canvas.drawPaint(baseBackgroundColor);
    super.render(model, canvas);
  }

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------
  // Called by NodeManager
  @override
  void update(double dt) {
    switch (customeState) {
      case BootState.delaying:
        if (delay.expired(dt)) {
          customeState = BootState.sendSignal;
        }
        break;
      case BootState.sendSignal:
        // Boot simply exits the stage immediately. The NM will immediately
        // pop this node from the Top which inactivates it.
        sendSignal(NodeSignal.requestNodeLeaveStage);
        break;
      default:
        break;
    }
  }
}
