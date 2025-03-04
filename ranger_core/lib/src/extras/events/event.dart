import 'package:flutter/widgets.dart';

abstract class Event {
  // void mouseMove(Offset position, Offset delta);
  Offset? position;

  void reset();
}

class MouseEvent extends Event {
  // void mouseMove(Offset position, Offset delta) {
  //   this.position = position;
  //   this.delta = delta;
  // }

  @override
  void reset() {
    position = null;
  }
}

class MousePanEvent extends Event {
  Offset? delta;

  // Drag = Pan
  bool isDragging = false;
  bool isDragDown = false;
  bool isDragStart = false;
  bool isDragUpdate = false;
  bool isDragEnd = false;

  @override
  void reset() {
    isDragDown = false;
    isDragStart = false;
    isDragUpdate = false;
    isDragEnd = false;

    position = null;
    delta = null;
  }
}

class MousePointerEvent extends Event {
  Offset? delta;

  @override
  void reset() {
    position = null;
    delta = null;
  }
}
