import 'package:flutter/material.dart';

import '../shapes/shape.dart';
import 'renderer.dart';

class SquareRenderer extends Renderer {
  final Shape shape;

  SquareRenderer(this.shape);

  factory SquareRenderer.create(Shape shape) => SquareRenderer(shape);

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
