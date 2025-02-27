import 'package:flutter/material.dart';

import '../../extras/events/event.dart';
import '../../maths/matrix4.dart' as maths;
import '../../graph/node.dart';
import '../../world_core.dart';
import '../fonts/vector/path_text.dart';
import '../renderers/path_renderer.dart';
import '../renderers/renderer.dart';
import '../shapes/atlas.dart';
import '../shapes/path_shape.dart';

class StaticTextNode extends Node {
  late Paint paint = Paint();
  final PathText textPath = PathText();
  late WorldCore world;
  late PathShape shape;
  late Renderer renderer;

  StaticTextNode();

  factory StaticTextNode.create(String text, WorldCore world, Node? parent,
      {double charSpacing = 1.0}) {
    StaticTextNode stn = StaticTextNode()
      ..initialize(text)
      ..parent = parent
      ..nodeMan = world.nodeManager
      ..world = world
      ..paint.color = Colors.white; // default of "white"

    // Set this Node as a child of the parent and make it render last.
    stn.parent?.children.addLast(stn);

    stn.shape.path = stn.textPath;

    stn.build(text, world.atlas, charSpacing);

    return stn;
  }

  void build(String text, Atlas atlas, double charSpacing) {
    // First create a shape that will be renderered.
    world.atlas.buildTextPath(text, textPath, charSpacing: charSpacing);
    shape = PathShape.createWithPath(textPath, 'AbbaText');

    // Add to Atlas for cache usage
    atlas.addShape(shape);

    // Now create a renderer using that shape.
    renderer = PathRenderer.create(shape);
  }

  @override
  void render(maths.Matrix4 model, Canvas canvas, Size size) {
    renderer.render(canvas, this);
  }

  @override
  void event(Event input) {}
}
