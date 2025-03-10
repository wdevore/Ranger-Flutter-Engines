import 'dart:ui';

import '../../maths/matrix4.dart';
import '../../geometry/point.dart';
import '../../graph/node.dart';
import '../../graph/spaces.dart';
import '../../maths/affinetransform.dart';
import '../../maths/zoom_transform.dart';
import '../../world_core.dart';
import '../events/event.dart';
import '../renderers/renderer.dart';
import '../renderers/zoom_renderer.dart';

/// This is a Node with no visual aspect (i.e. it has no Shape component)
class ZoomNode extends Node {
  // Simply sets the Canvas transform. No shape is renderered.
  late Renderer renderer;

  late WorldCore world;

  // Maintains accumulative transform
  late ZoomTransform zoomTransform;

  double zoomStepSize = 0.0;

  // State management
  int mx = 0;
  int my = 0;
  late Point zoomPoint;

  ZoomNode();

  factory ZoomNode.create(String name, WorldCore world, Node? parent) {
    ZoomNode z = ZoomNode()
      ..initialize(name)
      ..nodeMan = world.nodeManager
      ..world = world
      ..parent = parent;

    parent?.children.addLast(z);

    z.build(world);

    return z;
  }

  void build(WorldCore world) {
    zoomStepSize = 0.1;

    zoomTransform = ZoomTransform.create();
    zoomPoint = Point();

    // We want input events from Mouse
    world.nodeManager.registerForEvents(this);

    renderer = ZoomRenderer.create();
  }

  // --------------------------------------------------------
  // Zooming
  // --------------------------------------------------------

  // SetStepSize sets the sensitivity of the zoom. If the view area
  // is very tight then you want smaller values so that zooming
  // doesn't jump by "glides"
  void setStepSize(double size) {
    zoomStepSize = size;
  }

  /// [setPosition] sets the zooms position and ripples to children
  /// mouse is located.
  @override
  void setPosition(double x, double y) {
    zoomTransform.setPosition(x, y);
    rippleDirty(true);
  }

  /// [setFocalPoint] sets the epi center of zoom
  void setFocalPoint(double x, double y) {
    zoomTransform.setAt(x, y);
    rippleDirty(true);
  }

  /// [scaleTo] sets the scale absolutely
  void scaleTo(double s) {
    zoomTransform.scale = s;
    rippleDirty(true);
  }

  /// [zoomScale] returns the zoom's current scale value
  double zoomScale() {
    return zoomTransform.psuedoScale;
  }

  /// [zoomBy] is relative zooming using deltas
  void zoomBy(double dx, double dy) {
    zoomTransform.zoomBy(dx, dy);
    rippleDirty(true);
  }

  /// [translateBy] is relative translation
  void translateBy(double dx, double dy) {
    zoomTransform.translateBy(dx, dy);
    rippleDirty(true);
  }

  /// [zoomIn] zooms inward making things bigger
  void zoomIn() {
    zoomTransform.zoomBy(zoomStepSize, zoomStepSize);
    rippleDirty(true);
  }

  /// [zoomOut] zooms outward making things smaller
  void zoomOut() {
    zoomTransform.zoomBy(-zoomStepSize, -zoomStepSize);
    rippleDirty(true);
  }

  // --------------------------------------------------------
  // Transforms
  // --------------------------------------------------------

  /// [calcTransform] : zoom nodes manage their own transform differently.
  @override
  AffineTransform calcTransform() {
    if (dirty) {
      zoomTransform.update();
      dirty = false;
    }

    return zoomTransform.transform;
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------

  @override
  void event(Event event, double dt) {
    switch (event) {
      case MouseEvent e:
        if (e.position != null) {
          mx = e.position!.dx.toInt();
          my = e.position!.dy.toInt();

          // This gets the local-space coords of the rectangle node.
          Spaces.mapDeviceToNode(
            world,
            mx,
            my,
            this,
            zoomPoint,
          );

          setFocalPoint(zoomPoint.x, zoomPoint.y);
          // print(zoomPoint);
        }
        break;
      case MousePointerEvent e:
        // Negative delta = zoom in
        // Positive delta = zoom out
        if (e.delta != null) {
          if (e.delta!.dy < 0.0) {
            // print('zoomin');
            zoomIn();
          } else {
            // print('zoomout');
            zoomOut();
          }
        }
        break;
      default:
        // throw UnimplementedError('$name: Unknown Event type');
        break;
    }
  }

  @override
  void render(Matrix4 model, Canvas canvas, Size size) {
    renderer.render(model, canvas, this);
  }
}
