import 'package:flutter/material.dart';

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
  void render(mat.Matrix4 model, Canvas canvas) {
    // TODO: implement draw
  }

  @override
  void event() {
    // TODO: implement event
  }

  @override
  void timing(dt) {
    // TODO: implement timing
  }
}
