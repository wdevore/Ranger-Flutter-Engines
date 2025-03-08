import 'package:flutter/widgets.dart';

abstract class Event {
  // void mouseMove(Offset position, Offset delta);
  Offset? position;
  Offset? delta;

  void reset();
}

class MouseEvent extends Event {
  @override
  void reset() {
    position = null;
    delta = null;
  }
}

class MousePanEvent extends Event {
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
  @override
  void reset() {
    position = null;
    delta = null;
  }
}
