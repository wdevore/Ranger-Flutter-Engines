import 'dart:math';

import 'geometry.dart';
import 'point.dart';

/// Rectangle is a square with behaviours.
/// It matches [Canvas].
///
///     minX,minY      >
///          .--------------------.
///          |        Top         |
///          |                    |
///          |                    |
///       >  | Left    .   right  |  <
///          |                    |
///          |                    |
///          |      bottom        |
///          .--------------------.
///                     <     maxX, maxY
///
///
class Rectangle extends Geometry {
  double left = 0.0;
  double top = 0.0;
  double bottom = 0.0;
  double right = 0.0;
  double width = 0.0;
  double height = 0.0;
  Point center = Point.create();

  Rectangle();

  factory Rectangle.zero() => Rectangle();

  void setCopy(Rectangle re) {
    bottom = re.bottom;
    left = re.left;
    top = re.top;
    right = re.right;
    width = re.width;
    height = re.height;
  }

  void setBySize(double width, double height) {
    bottom = 0.0;
    left = 0.0;
    top = height;
    right = width;
    this.width = width;
    this.height = height;
  }

  void setByMinMax(double minX, double minY, double maxX, double maxY) {
    left = minX;
    right = maxX;
    top = maxY;
    bottom = minY;
    width = maxX - minX;
    height = maxY - minY;
  }

  void setCenter(double x, double y) {
    center.x = x;
    center.y = y;
  }

  /// Expands/Fits rectangle to fit vertex cloud and set cente
  ///
  /// List is structured as: [x,y,x,y...]
  void setByVectexCloud(List<double> vertices) {
    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = -double.infinity;
    var maxY = -double.infinity;

    // Find min/max points
    for (var i = 0; i < vertices.length; i += 2) {
      var x = vertices[i];
      var y = vertices[i + 1];

      minX = min(minX, x);
      minY = min(minY, y);

      maxX = max(maxX, x);
      maxY = max(maxY, y);
    }

    setByMinMax(minX, minY, maxX, maxY);
    setCenter(left + width / 2.0, bottom + height / 2.0);
  }

  /// Expands rectangle by delta width and height, and set cente
  void expand(double wx, double wy) {
    var minX = left;
    var minY = bottom;
    var maxX = right;
    var maxY = top;

    minX = min(minX, wx);
    minY = min(minY, wy);

    maxX = max(maxX, wx);
    maxY = max(maxY, wy);

    setByMinMax(minX, minY, maxX, maxY);
    setCenter(left + width / 2.0, bottom + height / 2.0);
  }

  double get area => width * height;

  /// Adjusts dimensions without centering.
  void setSize(double w, double h) {
    width = w;
    height = h;
  }

  /// [pointContained] checks point using left-top rule.
  ///
  /// Rule: Point is **NOT** inside if on an Edge.
  bool pointContained(Point p) {
    return p.x > left && p.x < (right) && p.y > bottom && p.y < (top);
  }

  /// [pointInside] checks point using left-top rule.
  ///
  /// Rule: Point is inside if on an top or left Edge and **NOT** on a bottom or right edge
  @override
  bool pointInside(Point p) {
    // Because the Canvas's +Y is downward the bottom is positive so the check is:
    // y is < bottom and y is >= top.
    return p.x >= left && p.x < right && p.y < bottom && p.y >= top;
  }

  @override
  bool coordsInside(double x, double y) {
    // print('$x >= $left && $x < $right && $y >= $bottom && $y < $top');
    //  Canvas's device coordinate space is:
    //        Top-Left
    //         (0,0)
    //           .--------> +X
    //           |
    //           |
    //           |
    //           v         Bottom-Right
    //          +Y
    //      Lower-Left
    //
    // If +Y is upward
    // return x >= left && x < right && y >= bottom && y < top;
    //
    // Because the Canvas's +Y is downward the bottom is positive so the check is:
    // y is < bottom and y is >= top.
    return x >= left && x < right && y < bottom && y >= top;
  }

  /// [intersects] returns *true* if other (o) intersects this rectangle.
  bool intersects(Rectangle o) {
    return left <= o.right &&
        o.left <= right &&
        top <= o.bottom &&
        o.top <= bottom;
    // return left <= o.right &&
    //     o.left <= right &&
    //     bottom <= o.top &&
    //     o.bottom <= top;
  }

  /// [contains] returns *true* if rectangle completely contains other (o).
  bool contains(Rectangle o) {
    return left <= o.left &&
        right >= o.right &&
        top <= o.top &&
        bottom >= o.bottom;
  }

  @override
  String toString() {
    return 'LT: ($left,$top) RB: ($right,$bottom) [$width x $height]';
  }
}
