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

  /// [construct] is called by the Engine during Construct(). The Under/Over lays may
  /// be populated afterwards.
  @override
  void construct() {}

  @override
  void end() {
    nodeManager.close();
  }
}
