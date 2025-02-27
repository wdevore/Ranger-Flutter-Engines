import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'char_vectors.dart';
import 'path_text.dart';
import 'vector_font.dart';

/// Converts vector lists into a Canvas Path.
/// The Anchor position defaults to the center of first character.
class VectorText {
  static const whiteSpacing = 0.5;
  double width = 0.0;
  double height = 0.0;

  void buildPath(String text, PathText pathText, VectorFont vectorFont,
      {double charSpacing = 1.0}) {
    List<String> chars = text.split('');
    pathText.path.reset();

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

        width = max(width, charWidth);
        height = max(height, cvs.height);

        // Build Path
        for (var path in cvs.paths) {
          cv = path.elementAt(0);
          // A moveTo starts each path.
          pathText.path.moveTo(cv.x + offset, cv.y);
          for (var i = 1; i < path.length; i++) {
            cv = path.elementAt(i);
            pathText.path.lineTo(cv.x + offset, cv.y);
          }
        }
        offset += charSpacing + charWidth;
      }
    }

    pathText
      ..width = width
      ..height = height;
  }
}
