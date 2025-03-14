import 'package:flutter/material.dart';

import 'shape.dart';

/// The [Shape] is assigned an [id] when it is added to the [Atlas].
class SquareShape extends Shape {
  late Rect rect;
  Paint paint = Paint()
    ..color = Colors.lime
    ..style = PaintingStyle.fill;
  Paint paintAlt = Paint()
    ..color = Colors.limeAccent
    ..style = PaintingStyle.fill;

  SquareShape(this.rect);

  factory SquareShape.create(Rect rect, String name) {
    SquareShape ss = SquareShape(rect)..name = name;
    return ss;
  }

  @override
  void draw(Canvas canvas) {
    if (!collision) {
      canvas.drawRect(
        rect,
        paint,
      );
    } else {
      canvas.drawRect(
        rect,
        paintAlt,
      );
    }
  }
}
