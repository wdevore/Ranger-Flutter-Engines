import 'package:flutter/widgets.dart';

enum EventState {
  none,
  buttonLeft,
  buttonRight,
  buttonMiddle,
  down,
  up,
  cancelled,
  dragging,
}

abstract class Event {
  EventState buttonState = EventState.none;
  Offset? position;
  Offset? delta;

  void reset() {
    buttonState = EventState.none;
    position = null;
    delta = null;
  }
}

class MouseEvent extends Event {}

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

    super.reset();
  }
}

class MousePointerEvent extends Event {}

class KeyboardEvent extends Event {
  bool isKeyDown = false;
  bool isKeyUp = false;
  bool isKeyRepeat = false;

  String key = '';

  @override
  void reset() {
    isKeyDown = false;
    isKeyUp = false;
    isKeyRepeat = false;
    key = '';

    super.reset();
  }
}
