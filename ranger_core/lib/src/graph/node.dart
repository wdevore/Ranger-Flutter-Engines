import 'package:flutter/material.dart';

import '../extras/events/event.dart';
import '../geometry/rectangle.dart';
import '../maths/affinetransform.dart';
import '../maths/matrix4.dart' as mat;
import 'filters/filter.dart';
import 'group.dart';
import 'event.dart';
import 'node_signals.dart';
import 'node_manager.dart';
import 'transform.dart' as trxs;
import 'transform_stack_cached.dart';

enum NodeState {
  /// Node maintains its current state (i.e. running)
  maintain,
  delaying,

  /// Send signal to NodeManger
  sendSignal,

  /// Wait for a response signal from NodeManager
  waitSignal,
}

enum NodeSignal {
  /// A Node wants to leave stage
  requestNodeLeaveStage,

  /// A Node is given permission to leave
  leaveStageGranted,

  /// Notify a Node that it has moved to the Top
  nodeMovedToStage,
}

/// Nodes maintain their own state, however, there are common states that
/// many may hold.
abstract class Node with trxs.Transform, Group, Signals, Events {
  // Internal incrementing node id counter
  static int _iDcnt = 0;

  late NodeManager nodeMan;

  NodeState state = NodeState.maintain;

  int id = 0;
  String name = '';

  bool visible = true;

  bool dirty = true;

  Node? parent;

  late Rectangle bounds;

  void initialize(String name) {
    this.name = name;
    id = _iDcnt++;
    bounds = Rectangle.zero();
    initializeTransform();
    initializeGroup();
  }

  /// [visit] traverses **down** the heirarchy while space-mappings traverses
  /// **upward**.
  static void visit(
    Node node,
    TransformStackCached stack,
    double interpolation,
    Canvas canvas,
    Size size,
  ) {
    // Checking visibility here would cause any children that are visible
    // to not be rendered.
    // TODO Add parent and children flags for individual control.
    if (!node.visible) {
      // fmt.Printf("Node.Visit %v: Visible: %v\n", node, node.IsVisible())
      return;
    }

    stack.save();

    // TODO Because position and angles are dependent on lerping we perform
    // interpolation first.
    // node.interpolate(interpolation);

    var aft = node.calcTransform();

    var model = stack.applyAffine(aft);

    // TODO add Atlas features for images
    node.render(model, canvas, size);

    // Some of the children may still be visible.
    // TODO add extra flag to choose if parent only or all children are visible
    // this will minimize bubbling.
    // Note: if you want the parent AND children to be invisible then you
    // need to bubble visibility to parent and children.

    // if (node.children.isNotEmpty) {
    for (var node in node.children) {
      if (node is Filter) {
        // TODO add filter.visit(stack, interpolation)
      } else {
        // Recurse down the tree.
        visit(node, stack, interpolation, canvas, size);
      }
    }
    // }

    stack.restore();
  }

  /// [calcTransform] calculates a matrix based on the
  /// current transform properties
  AffineTransform calcTransform() {
    if (dirty) {
      aft.makeTranslate(position.x, position.y);

      if (rotation != 0.0) {
        aft.rotate(rotation);
      }

      if (scale.x != 1.0 || scale.y != 1.0) {
        aft.scale(scale.x, scale.y);
      }

      // Invert...
      aft.invertTo(inverse);
    }

    return aft;
  }

  /// [render] provides a default render--which is to draw nothing.
  ///
  /// You must **override** this in your custom [Node] if your [Node]
  /// needs to perform custom rendering.
  void render(mat.Matrix4 model, Canvas canvas, Size size) {}

  void setPosition(double x, double y) {
    position.x = x;
    position.y = y;
    rippleDirty(true);
  }

  void setRotation(double radians) {
    rotation = radians;
    rippleDirty(true);
  }

  void setScale(double scale) {
    this.scale.x = scale;
    this.scale.y = scale;
    rippleDirty(true);
  }

  void rippleDirty(bool dirty) {
    for (var child in children) {
      child.rippleDirty(dirty);
    }

    this.dirty = dirty;
  }

// SetBoundBySize set bounds centered at node's position.
  void setBoundBySize(double w, double h) {
    var hw = w / 2.0;
    var hh = h / 2.0;
    bounds.setByMinMax(
      position.x - hw,
      position.y - hh,
      position.x + hw,
      position.y + hh,
    );
  }

  bool hasParent() => parent != null;

  void update(double dt) {
    // Recurse in children.
    for (var child in children) {
      child.update(dt);
    }
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  // Receive signal from NM
  @override
  void receiveSignal(NodeSignal signal);

  // Send signal to NM
  @override
  void sendSignal(NodeSignal signal) {
    nodeMan.sendSignal(this, signal);
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------
  void event(Event input);

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------
  void timing(double dt) {}

  @override
  String toString() {
    return ':\'$name\' ($id):';
  }
}
