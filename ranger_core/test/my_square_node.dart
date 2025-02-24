import 'package:flutter/material.dart';
import 'package:ranger_core/src/extras/events/event.dart';
import 'package:ranger_core/src/extras/shapes/atlas.dart';
import 'package:ranger_core/src/extras/shapes/square_shape.dart';
import 'package:ranger_core/src/graph/node.dart';
import 'package:ranger_core/src/maths/matrix4.dart' as maths;
import 'package:ranger_core/src/world_core.dart';

class MySquareNode extends Node {
  late Paint paint = Paint();
  late SquareShape shape;

  MySquareNode();

  // [parent] is of type Node not "Node?" because leaf nodes always have a parent.
  factory MySquareNode.create(String name, WorldCore world, Node parent) {
    MySquareNode my = MySquareNode()
      ..initialize(name)
      ..parent = parent
      ..paint.color = Colors.white; // default of "white"

    my.parent?.children.addLast(my);
    my.build(world.atlas);

    return my;
  }

  void build(Atlas atlas) {
    SquareShape shape = SquareShape.create(Atlas.createSquareRect(), name);
    atlas.addShape(shape);
  }

  @override
  void render(maths.Matrix4 model, Canvas canvas, Size size) {
    // Finally call render incase the base Node want to decorate/adorn it.
    super.render(model, canvas, size);
  }

  @override
  void event(Event event) {
    // TODO: implement event
  }
}
