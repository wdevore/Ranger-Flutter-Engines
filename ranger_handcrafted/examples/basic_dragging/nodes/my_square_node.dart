import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart' as core;

class MySquareNode extends core.Node {
  late Paint paint = Paint();
  late core.SquareShape shape;

  late core.WorldCore world;
  late core.Renderer renderer;

  double angle = 0.0;
  final double angleRate = 0.01; // radians per (1/framerate)

  final core.Point localPosition = core.Point.create();
  final core.DragState dragState = core.DragState.create();

  MySquareNode();

  /// [parent] is of type Node not "Node?" because leaf nodes always have a
  /// parent.
  factory MySquareNode.create(
    String name,
    double initialAngle,
    core.WorldCore world,
    core.Node? parent,
  ) {
    MySquareNode my = MySquareNode()
      ..initialize(name)
      ..parent = parent
      ..nodeMan = world.nodeManager
      ..world = world
      ..angle = initialAngle
      ..paint.color = Colors.white; // default of "white";

    my.parent?.children.addLast(my);
    my.build(world.atlas);

    return my;
  }

  void build(core.Atlas atlas) {
    // First create a shape that will be renderered.
    Rect rect = core.Atlas.createSquareRect();
    shape = core.SquareShape.create(rect, name);
    // Add to Atlas for cache usage
    atlas.addShape(shape);

    // Sync bounds to rectangle.
    //
    bounds
      ..top = rect.top
      ..left = rect.left
      ..bottom = rect.bottom
      ..right = rect.right
      ..width = rect.width
      ..height = rect.height;

    // Now create a renderer using that shape.
    renderer = core.SquareRenderer.create(shape);

    // We want input events from Mouse
    world.nodeManager.registerForEvents(this);
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(core.NodeSignal signal) {
    print('MySquareNode.receiveSignal $signal');
  }

  // --------------------------------------------------------------------------
  // Event targets (IO) (Only called if this Node registered itself)
  // --------------------------------------------------------------------------
  @override
  void event(core.Event event, double dt) {
    switch (event) {
      case core.MouseEvent e:
        shape.collision = _isMouseInNode(e.position);
        break;
      case core.MousePanEvent e:
        if (e.isDragDown) {
          shape.collision = _isMouseInNode(e.position);
          if (shape.collision) {
            dragState.setButtonUsing(
              e.position!.dx.toInt(),
              e.position!.dy.toInt(),
              world,
              core.EventState.buttonLeft,
              core.EventState.down,
              this,
            );
          }
        }

        if (e.isDragging && shape.collision) {
          dragState.setMotionUsing(
              e.position!.dx.toInt(), e.position!.dy.toInt(), world, this);

          position.x += dragState.delta.x;
          position.y += dragState.delta.y;
        }
        break;
      case core.KeyboardEvent e:
        if (e.isKeyDown) {
          print('holding ${e.key}');
        }
        break;
      default:
        // throw UnimplementedError('$name: Unknown Event type');
        break;
    }
  }

  bool _isMouseInNode(Offset? position) {
    if (position != null) {
      // This gets the local-space coords of the rectangle node.
      core.Spaces.mapDeviceToNode(
        world,
        position.dx.toInt(),
        position.dy.toInt(),
        this,
        localPosition,
      );
      // print('local: $localPosition => $bounds');
      // print('${e.position} => local: $localPosition');

      return bounds.coordsInside(localPosition.x, localPosition.y);
    }
    return false;
  }

  @override
  void render(core.Matrix4 model, Canvas canvas, Size size) {
    renderer.render(model, canvas, this);
    // Finally call render incase the base Node wants to decorate/adorn it.
    super.render(model, canvas, size);
  }

  @override
  void update(double dt) {
    switch (state) {
      // case NodeState.waitSignal:
      //   break;
      default:
        // Default is where most of the action takes place.
        setRotation(angle * core.degreesToRadians);
        angle += angleRate * dt;
        break;
    }
  }
}
