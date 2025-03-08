import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../graph/node.dart';
import 'renderer.dart';
import '../../maths/matrix4.dart' as matrix;

class ZoomRenderer extends Renderer {
  ZoomRenderer();

  factory ZoomRenderer.create() => ZoomRenderer();

  @override
  void render(matrix.Matrix4 model, Canvas canvas, Node node) {
    // TODO optimize this using a dirty flag
    Float64List f4 = model.toColumnMajorList();

    canvas.transform(f4);
  }

  @override
  void draw(Canvas canvas) {}
}
