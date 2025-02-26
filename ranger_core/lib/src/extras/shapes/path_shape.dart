import 'package:flutter/material.dart';

import 'shape.dart';

/// The [Shape] is assigned an [id] when it is added to the [Atlas].
class PathShape extends Shape {
  Path? path;
  Paint paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

  PathShape();

  factory PathShape.create(String name) {
    PathShape ss = PathShape()..name = name;
    return ss;
  }

  factory PathShape.createWithPath(Path path, String name) {
    PathShape ss = PathShape()
      ..path = path
      ..name = name;
    return ss;
  }

  @override
  void draw(Canvas canvas) {
    if (path != null) {
      canvas.drawPath(
        path!,
        paint,
      );
    }
  }
}
