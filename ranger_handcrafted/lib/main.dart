import 'package:flutter/material.dart';

import 'engine.dart';
import 'game_page.dart';

void main() {
  final Engine engine = Engine.create('relativePath', 'overrides');
  runApp(GameApp(engine: engine));
}
