import '../../geometry/point.dart';
import '../../graph/node.dart';
import '../../graph/spaces.dart';
import '../../world_core.dart';
import '../events/event.dart';

class DragState {
  bool dragging = false;
  bool active = false; // Track button down state

  Point positionDown = Point.create();
  Point positionUp = Point.create();
  Point position = Point.create();
  Point delta = Point.create();
  Point mapPoint = Point.create();

  DragState();

  factory DragState.create() => DragState();

  void setMotion(int x, int y) {
    if (active && dragging) {
      delta
        ..x = -position.x
        ..y = -position.y;
      position
        ..x = x.toDouble()
        ..y = y.toDouble();
    }
  }

  void setButtonState(int x, int y, EventState eventState, EventState state) {
    active =
        eventState == EventState.buttonLeft && state == EventState.dragging;

    if (active) {
      positionDown
        ..x = x.toDouble()
        ..y = y.toDouble();
      position
        ..x = positionDown.x
        ..y = positionDown.y;
    } else {
      positionUp
        ..x = x.toDouble()
        ..y = y.toDouble();
    }
  }

  void setMotionUsing(int x, int y, WorldCore world, Node node) {
    if (active && dragging) {
      // We need to map to parent space for dragging because the parent may
      // contain a scaling factor. Note: Using view-space will result in
      // drifting from scale difference.
      if (node.parent != null) {
        Spaces.mapDeviceToNode(
          world,
          x,
          y,
          node.parent!,
          mapPoint,
        );

        delta
          ..x = mapPoint.x - position.x
          ..y = mapPoint.y - position.y;
        position
          ..x = mapPoint.x
          ..y = mapPoint.y;
      }
    }
  }

  void setButtonUsing(int x, int y, WorldCore world, EventState button,
      EventState state, Node node) {
    active = button == EventState.buttonLeft;
    dragging = state == EventState.down;

    if (node.parent != null) {
      Spaces.mapDeviceToNode(
        world,
        x,
        y,
        node.parent!,
        mapPoint,
      );
    }

    if (active) {
      positionDown
        ..x = mapPoint.x
        ..y = mapPoint.y;
      position
        ..x = mapPoint.x
        ..y = mapPoint.y;
    } else {
      positionUp
        ..x = mapPoint.x
        ..y = mapPoint.y;
    }
  }
}
