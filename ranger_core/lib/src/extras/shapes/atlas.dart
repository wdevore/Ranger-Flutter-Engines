import 'package:flutter/material.dart';

import '../fonts/vector/path_text.dart';
import '../fonts/vector/vector_text.dart';
import '../fonts/vector/vector_font.dart';
import 'shape.dart';

/// A collection of generic shapes
class Atlas {
  static int idCnt = 0;
  static List<String> vectorFontData = VectorFont.loadDefaultVectorFont();
  final Map<String, Shape> shapes = {};
  late VectorFont vectorFont;
  final VectorText vectorText = VectorText();

  Atlas() {
    vectorFont = VectorFont.create(vectorFontData);
  }

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

  static Path createTrianglePath() {
    Path path = Path();

    path
      ..moveTo(-0.5, 0.5)
      ..lineTo(0.0, -0.5)
      ..lineTo(0.5, 0.5)
      ..close();

    return path;
  }

  void buildTextPath(String text, PathText pathText,
      {double charSpacing = 1.0}) {
    vectorText.buildPath(text, pathText, vectorFont, charSpacing: charSpacing);
  }
}
