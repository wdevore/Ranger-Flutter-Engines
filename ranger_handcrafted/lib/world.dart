import 'extras/group_node.dart';
import 'graph/event.dart';
import 'graph/node.dart';
import 'graph/node_manager.dart';
import 'graph/scene.dart';

class WorldException implements Exception {
  final String message;
  WorldException(this.message);
}

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

  World();

  factory World.create(String relativePath) {
    World w = World()
      ..sceneGraph = NodeManager.create()
      ..relativePath = relativePath;

    w.sceneGraph.configure(w);

    return w;
  }

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
    //                           /      \
    //                   In:Scene        Out:Scene
    //
    // From here the NM's job is to Add/Remove Scenes from the Scenes-Node

    // Create Root first and above all (pun intended) do it NOW! ;-)
    root = GroupNode.create('Root', this, null);

    underlay = GroupNode.create('Underlay', this, root);

    scenes = GroupNode.create('Scenes', this, root);

    overlay = GroupNode.create('Overlay', this, root);

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
