import 'dart:ui';

import 'package:flutter/material.dart';

import 'char_vectors.dart';
import 'vector_font.dart';

/// Converts vector lists into a Canvas Path.
/// The Anchor position defaults to the center of first character.
class StaticVectorText {
  static const whiteSpacing = 0.5;

  static Path buildPath(String text, VectorFont vectorFont,
      {double charSpacing = 1.0}) {
    Path polyLine = Path();

    List<String> chars = text.split('');
    polyLine.reset();

    double offset = 0.0;

    // For each char we offset the padding and width between each char
    // Each char width+spacing is added to each vertex of a following char.
    CharVertex cv;
    for (var char in chars) {
      if (char == ' ') {
        offset += whiteSpacing;
        continue;
      }

      if (vectorFont.characters.containsKey(char)) {
        CharVectors cvs = vectorFont.characters[char]!;
        double charWidth = cvs.width;
        // Build Path
        for (var path in cvs.paths) {
          cv = path.elementAt(0);
          // A moveTo starts each path.
          polyLine.moveTo(cv.x + offset, cv.y);
          for (var i = 1; i < path.length; i++) {
            cv = path.elementAt(i);
            polyLine.lineTo(cv.x + offset, cv.y);
          }
        }
        offset += charSpacing + charWidth;
      }
    }

    return polyLine;
  }
}
