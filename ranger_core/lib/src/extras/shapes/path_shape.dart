import 'package:flutter/material.dart';

import 'shape.dart';

/// The [Shape] is assigned an [id] when it is added to the [Atlas].
class PathShape extends Shape {
  final Path path;
  Paint paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

  PathShape(this.path);

  factory PathShape.create(Path path, String name) {
    PathShape ss = PathShape(path)..name = name;
    return ss;
  }

  @override
  void draw(Canvas canvas) {
    canvas.drawPath(
      path,
      paint,
    );
  }
}
