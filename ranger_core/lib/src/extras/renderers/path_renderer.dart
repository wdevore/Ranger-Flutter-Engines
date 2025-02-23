import 'package:flutter/material.dart';

import '../shapes/shape.dart';
import 'renderer.dart';

class PathRenderer extends Renderer {
  final Shape shape;

  PathRenderer(this.shape);

  factory PathRenderer.create(Shape shape) => PathRenderer(shape);

  @override
  void draw(Canvas canvas) {
    // Base axies are:
    // .------------> +X
    // |
    // |
    // |
    // |
    // |
    // v +Y
    shape.draw(canvas);
  }
}
