import 'package:flutter/material.dart';

abstract class Shape {
  late String name;
  late int id; // Used for querying and referencing from cache.

  /// [canvas] is a [CustomPainter] renderer used in Flutter
  void draw(Canvas canvas);
}
