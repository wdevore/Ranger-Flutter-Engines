import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart' as core;

import '../world.dart';

class MySquareNode extends core.Node {
  late Paint paint = Paint();
  late core.SquareShape shape;
  late World world;
  late core.Renderer renderer;
  double angle = 0.0;
  final double angleRate = 0.01; // radians per (1/framerate)

  MySquareNode();

  /// [parent] is of type Node not "Node?" because leaf nodes always have a
  /// parent.
  factory MySquareNode.create(
      String name, double initialAngle, World world, core.Node parent) {
    MySquareNode my = MySquareNode()
      ..initialize(name)
      ..parent = parent
      ..world = world
      ..angle = initialAngle
      ..paint.color = Colors.white; // default of "white";

    my.parent?.children.addLast(my);
    my.build(world.atlas);

    return my;
  }

  void build(core.Atlas atlas) {
    // First create a shape that will be renderered.
    core.SquareShape shape =
        core.SquareShape.create(core.Atlas.createSquareRect(), name);
    // Add to Atlas for cache usage
    atlas.addShape(shape);
    // Now create a renderer using that shape.
    renderer = core.SquareRenderer.create(shape);
  }

  /// Override [Node]'s [update] method in order to get timing target events.
  /// You must register this node as a timing target with the [NodeManager].
  @override
  void update(double msPerUpdate, double secPerUpdate) {
    setRotation(angle * core.degreesToRadians);
    angle += angleRate * msPerUpdate;

    super.update(msPerUpdate, secPerUpdate);
  }

  @override
  void render(core.Matrix4 model, Canvas canvas) {
    renderer.render(canvas, this);
    // Finally call render incase the base Node wants to decorate/adorn it.
    super.render(model, canvas);
  }
}
