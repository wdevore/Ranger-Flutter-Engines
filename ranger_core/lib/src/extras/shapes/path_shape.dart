import 'package:flutter/material.dart';

import '../fonts/vector/path_text.dart';
import 'shape.dart';

/// The [Shape] is assigned an [id] when it is added to the [Atlas].
class PathShape extends Shape {
  PathText? path;
  Paint paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke;

  PathShape();

  factory PathShape.create(String name) {
    PathShape ss = PathShape()..name = name;
    return ss;
  }

  factory PathShape.createWithPath(PathText path, String name) {
    PathShape ss = PathShape()
      ..path = path
      ..name = name;
    return ss;
  }

  @override
  void draw(Canvas canvas) {
    if (path != null) {
      canvas.drawPath(
        path!.path,
        paint,
      );
    }
  }
}
