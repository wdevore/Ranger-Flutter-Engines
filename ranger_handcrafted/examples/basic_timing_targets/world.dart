import 'dart:collection';

import 'package:ranger_core/ranger_core.dart';

/// [World] is contained within the [Engine]
class World {
  // -----------------------------------------
  // Scene graph is a node manager
  // -----------------------------------------
  late NodeManager sceneGraph;
  late Node root;
  late Node underlay;
  late Node scenes;
  late Node overlay;

  late String relativePath;

  final Atlas atlas = Atlas();

  World();

  factory World.create(String relativePath) {
    World w = World()
      ..sceneGraph = NodeManager.create()
      ..relativePath = relativePath;

    w.sceneGraph.configure();

    return w;
  }

  ListQueue<Node> get sceneStack => sceneGraph.stack.stack;

  /// [begin] is called by the Engine during Construct(). The Under/Over lays may
  /// be populated afterwards.
  void begin() {
    // The NodeManager needs to build a baseline Node structure for
    // the runtime environment. Structure:
    //
    //                            Root
    //         /-----------------/  | \-----------------\
    //         |                    |                   |
    //      Underlay              Scenes             Overlay
    //                              |
    //                              -- stack [Scenes]
    //                                    \
    //                                In:Scene -> Out:Scene
    //
    // From here the NM's job is to Add/Remove Scenes from the Scenes-Node

    // Create Root first and above all (pun intended) do it NOW! ;-)
    root = GroupNode.create('Root', null);

    underlay = GroupNode.create('Underlay', root);

    scenes = GroupNode.create('Scenes', root);

    overlay = GroupNode.create('Overlay', root);

    sceneGraph.root = root;
  }

  void end() {
    sceneGraph.end();
  }

  /// Push node onto the top
  void push(Node scene) {
    sceneGraph.pushNode(scene);
  }

  void routeEvents(Event event) {
    // NodeManager().RouteEvents(event);
  }
}
