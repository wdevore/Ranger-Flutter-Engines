import 'dart:ui';

import 'graph/node_manager.dart';
import 'maths/matrix4.dart';

abstract class WorldCore {
  late String relativePath;
  late NodeManager nodeManager;

  final Matrix4 viewSpace = Matrix4.identity();
  final Matrix4 invViewSpace = Matrix4.identity();
  Size? deviceSize;

  /// [construct] is called by the Engine during Construct().
  void construct();

  void end() {
    nodeManager.close();
  }
}
