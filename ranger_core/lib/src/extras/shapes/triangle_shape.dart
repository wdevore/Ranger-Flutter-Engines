import 'package:flutter/material.dart';

import 'shape.dart';

/// The [Shape] is assigned an [id] when it is added to the [Atlas].
class TriangleShape extends Shape {
  final Path path;
  Paint paint = Paint()
    ..color = Colors.lime
    ..style = PaintingStyle.fill;
  Paint paintAlt = Paint()
    ..color = Colors.limeAccent
    ..style = PaintingStyle.fill;

  TriangleShape(this.path);

  factory TriangleShape.create(Path path, String name) {
    TriangleShape ss = TriangleShape(path)..name = name;

    return ss;
  }

  @override
  void draw(Canvas canvas) {
    if (!collision) {
      canvas.drawPath(
        path,
        paint,
      );
    } else {
      canvas.drawPath(
        path,
        paintAlt,
      );
    }
  }
}
