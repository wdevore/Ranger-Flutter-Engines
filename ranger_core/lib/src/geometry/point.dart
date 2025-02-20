import '../maths/matrix4.dart';
import 'geometry.dart';

class Point extends Geometry {
  double x = 0.0;
  double y = 0.0;

  Point();

  factory Point.create() => Point();

  factory Point.createXY(double x, double y) => Point()
    ..x = x
    ..y = y;

  /// [mulPoint] left-multiplies the point by the given matrix
  /// assuming the 3rd component = 0, fourth (w) component = 1.
  ///
  ///     |M00 M01 M02 M03|
  ///     |M10 M11 M12 M13|
  ///     |M20 M21 M22 M23|
  ///     |M30 M31 M32 M33|
  void mulPoint(Matrix4 m) {
    // vector = x, y, 0, 1
    var s = m.e;
    x = x * s[Matrix4.m00] + y * s[Matrix4.m01] + s[Matrix4.m03];
    y = x * s[Matrix4.m10] + y * s[Matrix4.m11] + s[Matrix4.m13];
  }

  @override
  String toString() {
    return '($x, $y)';
  }
}
