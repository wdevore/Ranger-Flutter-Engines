import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../graph/node.dart';
import '../../maths/affinetransform.dart';

abstract class Renderer {
  /// [canvas] is a [CustomPainter] renderer used in Flutter
  void render(Canvas canvas, Node node) {
    canvas.save();

    // TODO use matrix instead
    // Float64List f4 = Renderer.toColumnMajorList(node.calcTransform());
    // canvas.transform(f4);

    canvas.translate(node.position.x, node.position.y);

    if (node.rotation != 0.0) {
      canvas.rotate(node.rotation);
    }

    if (node.scale.x != 0 || node.scale.y != 0) {
      canvas.scale(node.scale.x, node.scale.y);
    }

    draw(canvas);

    canvas.restore();
  }

  void draw(Canvas canvas);

  static Float64List toColumnMajorList(AffineTransform aft) {
    Float64List f4 = Float64List.fromList(aft.m);
    return f4;
  }
}
