import '../geometry/point.dart';
import '../maths/affinetransform.dart';
import '../world_core.dart';
import 'node.dart';

final Point _tViewPoint = Point.create();
final AffineTransform comp = AffineTransform.identity();
final AffineTransform out = AffineTransform.identity();

class Spaces {
  /// [mapDeviceToView] maps mouse-space device coordinates to view-space
  static void mapDeviceToView(
    WorldCore world,
    int dvx,
    int dvy,
    Point viewPoint,
  ) {
    viewPoint.x = dvx.toDouble();
    viewPoint.y = dvy.toDouble();

    viewPoint.mulPoint(world.invViewSpace);
  }

  /// [mapDeviceToNode] maps mouse-space device coordinates to local node-space
  /// Optional scaling before returning from function. <b>Extremely</b> rare to use:
  ///
  ///     localPoint.SetByComp(localPoint.X() * node.Scale(), localPoint.Y() * node.Scale())
  static void mapDeviceToNode(
      WorldCore world, int dvx, int dvy, Node node, Point localPoint) {
    // Mapping from device to node requires transforms from two "directions"
    // 1st is upwards transform and the 2nd is downwards transform.

    // downwards from device-space to view-space
    // if (world.deviceSize != null) {
    //   dvy = world.deviceSize!.height.toInt() - dvy;
    //   print(dvy);
    // }
    mapDeviceToView(world, dvx, dvy, _tViewPoint);

    // Canvas and OpenGL have inverted Y axis. Canvas is +Y downward.
    // OpenGL's +Y axis is upwards so we either flip the Y axis here
    // or flip the mouse's +Y axis in cursorPosCallback(...)
    // dvr := node.World().Properties().Window.DeviceRes
    // MapDeviceToView(node.World(), dvx, int32(dvr.Height)-dvy, tViewPoint)

    // Upwards from node to world-space (aka view-space)
    AffineTransform wtn = worldToNodeTransform(node, null);

    // Now map view-space point to local-space of node
    wtn.transformXYPoint(_tViewPoint.x, _tViewPoint.y, localPoint);
  }

  /// [mapNodeToNode] maps node's local origin (0,0) to another node's space
  /// Supplying a psuedo-root can reduce multiplications, thus use it if possible.
  static void mapNodeToNode(
      Node sourceNode, Node destinationNode, Point nodePoint, Node psuedoRoot) {
    var ntw = nodeToWorldTransform(sourceNode, psuedoRoot);
    ntw.transformXYPoint(0.0, 0.0, nodePoint);
    // nodePoint is now in world-space

    var wtn = worldToNodeTransform(destinationNode, psuedoRoot); // nodePoint
    wtn.transformXYPoint(nodePoint.x, nodePoint.y, nodePoint);
    // nodePoint is now in the destination node's space

    // OR via view-space (not recommended as it is extra operations and rounding)
    // MapNodeToDevice(sourceNode.World(), sourceNode, nodePoint)
    // MapDeviceToNode(int32(nodePoint.X()), int32(nodePoint.Y()), destinationNode, nodePoint)
  }

  /// [mapNodeToWorld] maps node's local origin to world-space
  static void mapNodeToWorld(Node node, Point point) {
    var ntw = nodeToWorldTransform(node, null);
    ntw.transformXYPoint(0.0, 0.0, point);
  }

  /// [mapWorldToNode] maps a world-space coord to a specific node
  static void mapWorldToNode(Node node, Point worldPoint, Point nodePoint) {
    var wtn = worldToNodeTransform(node, null); // nodePoint
    wtn.transformXYPoint(worldPoint.x, worldPoint.y, nodePoint);
  }

  /// [mapNodeToDevice] maps node local origin to device-space (aka mouse-space)
  static void mapNodeToDevice(WorldCore world, Node node, Point devicePoint) {
    var ntw = nodeToWorldTransform(node, null);
    ntw.transformXYPoint(0.0, 0.0, devicePoint);
    devicePoint.mulPoint(world.viewSpace);
  }

  /// [worldToNodeTransform] maps a world-space coordinate to local-space of node
  static AffineTransform worldToNodeTransform(Node node, Node? psuedoRoot) {
    var wtn = nodeToWorldTransform(node, psuedoRoot);
    wtn.invert();
    return wtn;
  }

  /// [nodeToWorldTransform] maps a local-space coordinate to world-space
  static AffineTransform nodeToWorldTransform(Node node, Node? psuedoRoot) {
    // A transform to accumulate the parent transforms.
    comp.setByTransform(node.calcTransform());

    // Iterate "upwards" starting with the child towards the parents
    // starting with this child's parent.
    var p = node.parent;

    while (p != null) {
      var parentT = p.calcTransform();

      // Because we are iterating upwards we need to pre-multiply each child.
      // Ex: [child] x [parent]
      // ----------------------------------------------------------
      //           [comp] x [parentT]
      //               |
      //               | out
      //               v
      //             [comp] x [parentT]
      //                 |
      //                 | out
      //                 v
      //               [comp] x [parentT...]
      //
      // This is a pre-multiply order
      // [child] x [parent of child] x [parent of parent of child]...
      //
      // In other words the child is mutiplied "into" the parent.
      AffineTransform.multiply(comp, parentT, out);
      comp.setByTransform(out);

      if (p == psuedoRoot) {
        // fmt.Println("SpaceMappings: hit psuedoRoot")
        break;
      }

      // next parent upwards
      p = p.parent;
    }

    return comp;
  }
}
