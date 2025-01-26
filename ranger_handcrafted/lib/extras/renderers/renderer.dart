import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../graph/node.dart';
import '../../maths/affinetransform.dart';

abstract class Renderer {
  /// [canvas] is a [CustomPainter] renderer used in Flutter
  void render(Canvas canvas, Node node);

  static Float64List toColumnMajorList(AffineTransform aft) {
    Float64List f4 = Float64List.fromList(aft.m);
    return f4;
  }
}
