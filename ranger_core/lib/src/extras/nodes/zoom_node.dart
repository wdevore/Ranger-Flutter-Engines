import '../../geometry/point.dart';
import '../../graph/node.dart';
import '../../graph/spaces.dart';
import '../../maths/affinetransform.dart';
import '../../maths/zoom_transform.dart';
import '../../world_core.dart';
import '../events/event.dart';

class ZoomNode extends Node {
  late WorldCore world;
  final Point localPosition = Point.create();

  late ZoomTransform zoom;

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

    zoom = ZoomTransform();
    zoomPoint = Point();

    // We want input events from Mouse
    world.nodeManager.registerForEvents(this);
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
    zoom.setPosition(x, y);
    rippleDirty(true);
  }

  /// [setFocalPoint] sets the epi center of zoom
  void setFocalPoint(double x, double y) {
    zoom.setAt(x, y);
    rippleDirty(true);
  }

  /// [scaleTo] sets the scale absolutely
  void scaleTo(double s) {
    zoom.scale = s;
    rippleDirty(true);
  }

  /// [zoomScale] returns the zoom's current scale value
  double zoomScale() {
    return zoom.psuedoScale;
  }

  /// [zoomBy] is relative zooming using deltas
  void zoomBy(double dx, double dy) {
    zoom.zoomBy(dx, dy);
    rippleDirty(true);
  }

  /// [translateBy] is relative translation
  void translateBy(double dx, double dy) {
    zoom.translateBy(dx, dy);
    rippleDirty(true);
  }

  /// [zoomIn] zooms inward making things bigger
  void zoomIn() {
    zoom.zoomBy(zoomStepSize, zoomStepSize);
    rippleDirty(true);
  }

  /// [zoomOut] zooms outward making things smaller
  void zoomOut() {
    zoom.zoomBy(-zoomStepSize, -zoomStepSize);
    rippleDirty(true);
  }

  // --------------------------------------------------------
  // Transforms
  // --------------------------------------------------------

  /// [calcTransform] : zoom nodes manage their own transform differently.
  @override
  AffineTransform calcTransform() {
    if (dirty) {
      zoom.update();
      dirty = false;
    }

    return zoom.transform;
  }

  // --------------------------------------------------------------------------
  // Event targets (IO)
  // --------------------------------------------------------------------------

  @override
  void event(Event event) {
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
            localPosition,
          );

          setFocalPoint(zoomPoint.x, zoomPoint.y);
        }
        break;
      case MousePointerEvent e:
        // Negative delta = zoom in
        // Positive delta = zoom out
        if (e.delta != null) {
          if (e.delta!.dy < 0.0) {
            zoomIn();
          } else {
            zoomOut();
          }
        }
        break;
      default:
        // throw UnimplementedError('$name: Unknown Event type');
        break;
    }
  }
}
