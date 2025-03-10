import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart' as core;

class TriShipNode extends core.Node {
  late Paint paint = Paint();
  late core.TriangleShape shape;

  late core.WorldCore world;
  late core.Renderer renderer;

  double angle = 0.0;
  final double angleRate = 0.1; // radians per (1/framerate)

  final core.Point localPosition = core.Point.create();

  TriShipNode();

  /// [parent] is of type Node not "Node?" because leaf nodes always have a
  /// parent.
  factory TriShipNode.create(
    String name,
    double initialAngle,
    core.WorldCore world,
    core.Node? parent,
  ) {
    TriShipNode my = TriShipNode()
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
    Path path = core.Atlas.createTrianglePath();
    shape = core.TriangleShape.create(path, name);
    shape.paint = Paint()
      ..color = Colors.lightBlueAccent
      ..style = PaintingStyle.fill;

    // Add to Atlas for cache usage
    atlas.addShape(shape);

    // Sync bounds to path polygon.
    // bounds
    //   ..top = rect.top
    //   ..left = rect.left
    //   ..bottom = rect.bottom
    //   ..right = rect.right
    //   ..width = rect.width
    //   ..height = rect.height;

    // Now create a renderer using that shape.
    renderer = core.PathRenderer.create(shape);

    // We want input events from Mouse
    world.nodeManager.registerForEvents(this);
  }

  // --------------------------------------------------------------------------
  // Signals between Nodes and NodeManager
  // --------------------------------------------------------------------------
  @override
  void receiveSignal(core.NodeSignal signal) {
    print('TriShipNode.receiveSignal $signal');
  }

  // --------------------------------------------------------------------------
  // Event targets (IO) (Only called if this Node registered itself)
  // --------------------------------------------------------------------------
  @override
  void event(core.Event event, double dt) {
    switch (event) {
      case core.KeyboardEvent e:
        if (e.isKeyDown) {
          // print('holding ${e.key}');
          switch (e.key) {
            case 'Arrow Left':
              angle -= angleRate * dt;
              break;
            case 'Arrow Right':
              angle += angleRate * dt;
              break;
            case 'F': // Thrust
              break;

            default:
              break;
          }
        }
        break;
      default:
        // throw UnimplementedError('$name: Unknown Event type');
        break;
    }
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
      default:
        // Default is where most of the action takes place.
        setRotation(angle * core.degreesToRadians);
        // angle += angleRate * dt;
        break;
    }
  }
}
