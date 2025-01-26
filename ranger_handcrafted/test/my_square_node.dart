import 'package:flutter/material.dart';
import 'package:ranger_handcrafted/extras/shapes/atlas.dart';
import 'package:ranger_handcrafted/extras/shapes/square_shape.dart';
import 'package:ranger_handcrafted/graph/node.dart';
import 'package:ranger_handcrafted/maths/matrix4.dart' as maths;
import 'package:ranger_handcrafted/world.dart';

class MySquareNode extends Node {
  late Paint paint = Paint();
  late SquareShape shape;

  MySquareNode();

  // [parent] is of type Node not "Node?" because lead nodes always have a
  // parent.
  factory MySquareNode.create(String name, World world, Node parent) {
    MySquareNode my = MySquareNode()
      ..world = world
      ..initialize(name)
      ..parent = parent
      ..paint.color = Colors.white; // default of "white";

    my.parent?.children.addLast(my);
    my.build(world.atlas);

    return my;
  }

  void build(Atlas atlas) {
    SquareShape shape = SquareShape.create(Atlas.createSquareRect(), name);
    atlas.addShape(shape);
  }

  @override
  void render(maths.Matrix4 model) {
    // Finally call render incase the base Node want to decorate/adorn it.
    super.render(model);
  }
}
