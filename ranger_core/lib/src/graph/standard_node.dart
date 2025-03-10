import 'package:flutter/material.dart';

import '../extras/events/event.dart';
import '../maths/matrix4.dart' as mat;
import 'node.dart';

final class StandardNode extends Node {
  StandardNode();

  factory StandardNode.create(String name) => StandardNode()..name = name;

  @override
  void initialize(String name) {
    // TODO stuff here
    super.initialize(name);
  }

  @override
  void render(mat.Matrix4 model, Canvas canvas, Size size) {
    // TODO: implement draw
  }

  @override
  void event(Event event, double dt) {
    // TODO: implement event
  }

  @override
  void timing(dt) {
    // TODO: implement timing
  }
}
