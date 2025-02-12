import 'package:ranger_core/ranger_core.dart' as core;

/// [World] is contained within the [Engine]
class World {
  // -----------------------------------------
  // Scene graph is a node manager
  // -----------------------------------------
  late core.NodeManager nodeManager;

  late String relativePath;

  final core.Atlas atlas = core.Atlas();

  World();

  factory World.create(String relativePath) {
    World w = World()
      ..nodeManager = core.NodeManager.create()
      ..relativePath = relativePath;

    w.nodeManager.configure();

    return w;
  }

  /// [construct] is called by the Engine during Construct(). The Under/Over lays may
  /// be populated afterwards.
  void construct() {}

  void end() {
    nodeManager.close();
  }

  void routeEvents(core.Events event) {
    // NodeManager().RouteEvents(event);
  }
}
