mixin Event {
  bool handled = true;

// Handled marks event as handled to stop event bubbling
  void makeHandled(bool mark) {
    handled = mark;
  }
}
