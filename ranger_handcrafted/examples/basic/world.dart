import 'package:ranger_core/ranger_core.dart' as core;

/// [World] is contained within the [Engine]
class World extends core.WorldCore {
  World();

  factory World.create(String relativePath) {
    World w = World()
      ..nodeManager = core.NodeManager.create()
      ..relativePath = relativePath;

    w.nodeManager.configure();

    return w;
  }

  /// [construct] is called by the Engine during Construct().
  @override
  void construct() {
    // Create Root first and above all (pun intended) do it NOW! ;-)
    // root = core.GroupNode.create('Root', null);

    // underlay = core.GroupNode.create('Underlay', root);

    // scenes = core.GroupNode.create('Scenes', root);

    // overlay = core.GroupNode.create('Overlay', root);

    // sceneGraph.root = root;
  }

  @override
  void end() {
    nodeManager.close();
  }
}
