import 'package:flutter/material.dart';

import '../../graph/node.dart';
import '../shapes/shape.dart';
import 'renderer.dart';

class SquareRenderer extends Renderer {
  final Shape shape;

  SquareRenderer(this.shape);

  factory SquareRenderer.create(Shape shape) => SquareRenderer(shape);

  @override
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

    // Base axies are:
    // .------------> +X
    // |
    // |
    // |
    // |
    // |
    // v +Y
    shape.draw(canvas);

    canvas.restore();
  }
}
