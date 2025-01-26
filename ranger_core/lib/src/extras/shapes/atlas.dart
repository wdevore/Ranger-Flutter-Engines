import 'package:flutter/material.dart';

import 'shape.dart';

/// A collection of shapes
class Atlas {
  static int idCnt = 0;
  final Map<String, Shape> shapes = {};

  Atlas();

  int addShape(Shape shape) {
    shape.id = idCnt++;
    shapes[shape.name] = shape;
    return shape.id;
  }

  static Rect createSquareRect([bool centered = true]) {
    Rect rect;
    if (centered) {
      rect = Rect.fromLTWH(
        -0.5,
        -0.5,
        0.5,
        0.5,
      );
    } else {
      rect = Rect.fromLTWH(
        0.0,
        0.0,
        1.0,
        1.0,
      );
    }
    return rect;
  }
}
