import 'dart:collection';

import 'package:ranger_core/ranger_core.dart' as core;

/// [World] is contained within the [Engine]
class World {
  // -----------------------------------------
  // Scene graph is a node manager
  // -----------------------------------------
  late core.NodeManager sceneGraph;
  late core.Node root;
  late core.Node underlay;
  late core.Node scenes;
  late core.Node overlay;

  late String relativePath;

  final core.Atlas atlas = core.Atlas();

  World();

  factory World.create(String relativePath) {
    World w = World()
      ..sceneGraph = core.NodeManager.create()
      ..relativePath = relativePath;

    w.sceneGraph.configure();

    return w;
  }

  ListQueue<core.Node> get sceneStack => sceneGraph.stack.stack;

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
    root = core.GroupNode.create('Root', null);

    underlay = core.GroupNode.create('Underlay', root);

    scenes = core.GroupNode.create('Scenes', root);

    overlay = core.GroupNode.create('Overlay', root);

    sceneGraph.root = root;
  }

  void end() {
    sceneGraph.end();
  }

  /// Push node onto the top
  void push(core.Node scene) {
    sceneGraph.pushNode(scene);
  }

  void routeEvents(core.Event event) {
    // TODO add routing of events
    // NodeManager().RouteEvents(event);
  }
}
