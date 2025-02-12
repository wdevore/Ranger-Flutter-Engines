import 'package:ranger_core/ranger_core.dart' as core;

/// [World] is contained within the [Engine]
class World {
  late String relativePath;
  late core.NodeManager nodeManager;

  final core.Atlas atlas = core.Atlas();

  World();

  factory World.create(String relativePath) {
    World w = World()
      ..nodeManager = core.NodeManager.create()
      ..relativePath = relativePath;

    w.nodeManager.configure();

    return w;
  }

  /// [construct] is called by the Engine during Construct().
  void construct() {}

  void end() {
    nodeManager.close();
  }

  void routeEvents(core.Events event) {
    // TODO add routing of events
    // NodeManager().RouteEvents(event);
  }
}
