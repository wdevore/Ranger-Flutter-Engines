import 'package:flutter/material.dart';

import '../../extras/events/event.dart';
import '../../maths/matrix4.dart' as maths;
import '../../graph/node.dart';
import '../../world_core.dart';
import '../renderers/path_renderer.dart';
import '../renderers/renderer.dart';
import '../shapes/atlas.dart';
import '../shapes/path_shape.dart';

class DynamicTextNode extends Node {
  late Paint paint = Paint();
  final Path textPath = Path();
  late WorldCore world;
  late PathShape shape;
  late Renderer renderer;

  DynamicTextNode();

  factory DynamicTextNode.create(String name, WorldCore world, Node? parent,
      {double charSpacing = 1.0}) {
    DynamicTextNode stn = DynamicTextNode()
      ..initialize(name)
      ..parent = parent
      ..nodeMan = world.nodeManager
      ..world = world
      ..paint.color = Colors.white; // default of "white"

    // Set this Node as a child of the parent and make it render last.
    stn.parent?.children.addLast(stn);

    stn
      ..shape = PathShape.create('DynaText')
      ..renderer = PathRenderer.create(stn.shape);

    stn.shape.path = stn.textPath;

    return stn;
  }

  void setText(String text, Atlas atlas, double charSpacing) {
    // First create a path construct a shape
    textPath.reset();
    Atlas.buildTextPath(text, textPath, charSpacing: charSpacing);
  }

  @override
  void render(maths.Matrix4 model, Canvas canvas, Size size) {
    renderer.render(canvas, this);
  }

  @override
  void event(Event input) {
    // TODO: implement event
  }
}
