import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart' as core;

class MySquareNode extends core.Node {
  late Paint paint = Paint();
  late core.SquareShape shape;
  late core.WorldCore world;
  late core.Renderer renderer;

  MySquareNode();

  // [parent] is of type Node not "Node?" because leaf nodes always have a
  // parent.
  factory MySquareNode.create(
      String name, core.WorldCore world, core.Node parent) {
    MySquareNode my = MySquareNode()
      ..initialize(name)
      ..parent = parent
      ..world = world
      ..paint.color = Colors.white; // default of "white";

    my.parent?.children.addLast(my);
    my.build(world.atlas);

    return my;
  }

  void build(core.Atlas atlas) {
    core.SquareShape shape =
        core.SquareShape.create(core.Atlas.createSquareRect(), name);
    atlas.addShape(shape);
    renderer = core.SquareRenderer(shape);
  }

  @override
  void render(core.Matrix4 model, Canvas canvas, Size size) {
    renderer.render(model, canvas, this);
    // Finally call render incase the base Node want to decorate/adorn it.
    super.render(model, canvas, size);
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------
  @override
  void event(core.Event event, double dt) {
    // TODO: implement event
  }

  // --------------------------------------------------------------------------
  // Timing targets (animations)
  // --------------------------------------------------------------------------

  @override
  void timing(double dt) {
    // TODO: implement timing
  }
}
