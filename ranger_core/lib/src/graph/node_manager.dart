import 'dart:collection';

import 'package:flutter/material.dart';

import '../exceptions.dart';
import '../maths/matrix4.dart' as mat;
import 'node.dart';
import 'transform_stack_cached.dart';

/// The [NodeManager] controls [Node] traversal.
///
/// Holds and manages the Nodes that represent the visual aspect of the Scene.
class NodeManager {
  // Clear or render background. Some nodes take the entire render area
  // so clearing or render a background is wasteful.
  bool clearBackground = false;

  // Matrix stack for recursive decent.
  late TransformStackCached transformStack;

  // Nodes hold string keys rather than actual Nodes.
  Map<String, Node> nodeMap = {};

  // The stack is used for Nodes that push other nodes onto the stack.
  // The Top is always render, so once a Node is pushed it is rendered.
  ListQueue<Node> nodeStack = ListQueue();
  bool popTheTop = false;

  //      Underlay           stack Top              Overlay
  Node? underlay;
  Node? overlay;

  // Some Nodes receive events that others don't, for example, a layer
  // vs a leaf. Usually animations sending timing events.
  List<Node> timingTargets = [];

  // Event targets are IO events.
  List<Node> eventTargets = [];

  final mat.Matrix4 preM4 = mat.Matrix4.identity();
  final mat.Matrix4 postM4 = mat.Matrix4.identity();

  NodeManager();

  factory NodeManager.create() {
    NodeManager nm = NodeManager();

    nm.transformStack = TransformStackCached.create();

    return nm;
  }

  void configure() {
    var identity = mat.Matrix4.identity();
    transformStack.initialize(identity);
  }

  // Called by GamePainter.paint() -> Engine.update()
  void update(double msPerUpdate, double secPerUpdate) {
    // Order is irrelevant.
    underlay?.update(msPerUpdate);

    // Iterate the Stack
    for (var node in nodeStack) {
      node.update(msPerUpdate);
    }

    // We can't pop a node while in the "for" above, so we capture for popping.
    if (popTheTop) {
      pop();
      popTheTop = false; // Make sure we don't pop again.
    }

    overlay?.update(msPerUpdate);
  }

  // --------------------------------------------------------------------------
  // Map and Stack
  // --------------------------------------------------------------------------
  void addNode(Node node) {
    nodeMap[node.name] = node;
  }

  void removeNode(String name) {
    if (nodeMap.containsKey(name)) {
      nodeMap.remove(name);
    }
  }

  void pushNode(String name) {
    Node? node = nodeMap[name];
    if (node != null) {
      nodeStack.addFirst(node);
    }
  }

  void pop() => nodeStack.removeFirst();
  Node get top => nodeStack.first;

  bool isNodeOnStage(Node node) => node.id == top.id;

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  /// Receive a signal sent from a Node. Called during an update().
  void sendSignal(Node node, NodeSignal signal) {
    switch (signal) {
      case NodeSignal.requestNodeLeaveStage:
        // Node requested to leave stage.
        // Check if on stage first.
        if (isNodeOnStage(node)) {
          popTheTop = true;
          // nodeTopPop = top;
          // Send signal to currently active Node
          node.receiveSignal(NodeSignal.leaveStageGranted);
          // Send signal to the next Node to activate, and that will be top+1
          nodeStack.elementAt(1).receiveSignal(NodeSignal.nodeMovedToStage);
        } else {
          throw NodeException(
              'NodeManager: attempt to remove Node from stage that wasn\'t at the top => $node');
        }
        break;
      default:
        break;
    }
  }

  // --------------------------------------------------------------------------
  // Recursive (render)
  // --------------------------------------------------------------------------
  // Called by GamePainter.paint() -> Engine.render.
  void visit(double interpolation, Canvas canvas) {
    // visit Underlay
    if (underlay != null) {
      transformStack.save();
      Node.visit(underlay!, transformStack, interpolation, canvas);
      transformStack.restore();
    }

    transformStack.save();
    Node.visit(top, transformStack, interpolation, canvas);
    transformStack.restore();

    // visit Overlay
    if (overlay != null) {
      transformStack.save();
      Node.visit(overlay!, transformStack, interpolation, canvas);
      transformStack.restore();
    }
  }

  /// [close] cleans up NodeManager by clearing the stack and clearing targets.
  void close() {
    eventTargets.clear();
    timingTargets.clear();
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------
  void event() {
    for (var target in eventTargets) {
      target.event();
    }
  }

  void registerEvent(Node target) {
    eventTargets.add(target);
  }

  void unRegisterEvent(Node target) {
    eventTargets.remove(target);
  }

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------
  void timing(double dt) {
    // TODO add visibility code so that updates are not called on objects that
    // are visible.
    for (var target in timingTargets) {
      target.timing(dt);
    }
  }

  void registerTarget(Node target) {
    timingTargets.add(target);
  }

  void unRegisterTarget(Node target) {
    timingTargets.remove(target);
  }
}
