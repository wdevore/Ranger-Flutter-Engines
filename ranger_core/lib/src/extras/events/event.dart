import 'package:flutter/widgets.dart';

abstract class Event {
  void mouseMove(Offset position, Offset delta);
}

class MouseEvent extends Event {
  Offset? position;
  Offset? delta;

  @override
  void mouseMove(Offset position, Offset delta) {
    this.position = position;
    this.delta = delta;
  }
}
