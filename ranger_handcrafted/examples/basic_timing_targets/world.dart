import 'package:ranger_core/ranger_core.dart' as core;

/// [World] is contained within the [Engine]
class World extends core.WorldCore {
  final core.Atlas atlas = core.Atlas();

  World();

  factory World.create(String relativePath) {
    World w = World()
      ..nodeManager = core.NodeManager.create()
      ..relativePath = relativePath;

    w.nodeManager.configure();

    return w;
  }

  @override
  void construct() {
    // TODO: implement construct
  }
}
