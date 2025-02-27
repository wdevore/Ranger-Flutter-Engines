import 'package:flutter/material.dart';

import '../fonts/vector/static_vector_text.dart';
import '../fonts/vector/vector_font.dart';
import 'shape.dart';

/// A collection of generic shapes
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
      rect = Rect.fromCenter(center: Offset(0.0, 0.0), width: 1.0, height: 1.0);
      // Above is equal to:
      // rect = Rect.fromLTWH(
      //   -0.5,
      //   -0.5,
      //   1.0,
      //   1.0,
      // );
    } else {
      // The top-left corner is:
      //    TL
      //   (0,0) <--- rotation is about this point
      //     .---------------.--> +X
      //     |       |       |
      //     |       |       |
      //     |-------.       | H
      //     |               |
      //     |               |
      //     |               |
      //     .---------------.(w,h) = BR
      //     |
      //     v
      //    +Y       W
      //
      // rect = Rect.fromLTWH(
      //   0.0,
      //   0.0,
      //   1.0,
      //   1.0,
      // );
      // If you want to rotate about the bottom-right (BR)
      //       TL
      //   (-0.5,-0.5)
      //        .--------........
      //        |       |       .
      //        |       |       .
      //        |-------.(0,0)  . H
      //        .        \      .
      //        .         \_________ rotation is about this point
      //        .               .
      //        ...............-.(w,h) BR
      //                W
      rect = Rect.fromLTWH(
        -0.5,
        -0.5,
        0.5,
        0.5,
      );
    }
    return rect;
  }

  static Path buildTextPath(String text, Path polyLine,
      {double charSpacing = 1.0}) {
    List<String> data = VectorFont.loadDefaultVectorFont();
    VectorFont vectorFont = VectorFont.create(data);

    Path textPath = StaticVectorText.buildPath(text, polyLine, vectorFont,
        charSpacing: charSpacing);

    return textPath;
  }
}
