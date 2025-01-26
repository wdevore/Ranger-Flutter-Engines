import 'package:flutter/material.dart';

import 'shape.dart';

/// Example:
///
///     MySquareNode node = MySquareNode.create('Square', world, parent);
///     SquareShape shape = SquareShape.create(Atlas.createSquareRect(), node.name);
///     int id = atlas.addShape(shape);
///     SquareRenderer renderer = SquareRenderer(shape);
///     renderer.render(canvas, node)
///
/// The [Shape] is assigned an [id] when it is added to the [Atlas].
class SquareShape extends Shape {
  final Rect rect;
  Paint paint = Paint()
    ..color = Colors.lime
    ..style = PaintingStyle.fill;

  SquareShape(this.rect);

  factory SquareShape.create(Rect rect, String name) {
    SquareShape ss = SquareShape(rect)..name = name;
    return ss;
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawRect(
      rect,
      paint,
    );
  }
}
