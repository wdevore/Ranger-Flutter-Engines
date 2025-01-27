import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart' as core;

import '../world.dart';

class MySquareNode extends core.Node {
  late Paint paint = Paint();
  late core.SquareShape shape;
  late World world;
  late core.Renderer renderer;

  MySquareNode();

  // [parent] is of type Node not "Node?" because lead nodes always have a
  // parent.
  factory MySquareNode.create(String name, World world, core.Node parent) {
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
  void render(core.Matrix4 model, Canvas canvas) {
    renderer.render(canvas, this);
    // Finally call render incase the base Node want to decorate/adorn it.
    super.render(model, canvas);
  }
}
