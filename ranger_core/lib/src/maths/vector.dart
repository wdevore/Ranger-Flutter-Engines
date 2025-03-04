import 'dart:math';

import 'constants.dart';

class Vector {
  double x = 0.0;
  double y = 0.0;
  static final Vector _tmp = Vector.create(0.0, 0.0);
  static final Vector _tmp2 = Vector.create(0.0, 0.0);

  Vector();

  factory Vector.create(double x, double y) {
    Vector v = Vector()
      ..x = x
      ..y = y;
    return v;
  }

  factory Vector.zero() => Vector();

  void setByAngle(double radians) {
    x = cos(radians);
    y = sin(radians);
  }

  double get length => sqrt(x * x + y * y);

  double get lenghSqr => x * x + y * y;

  void add(double x, double y) {
    this.x += x;
    this.y += y;
  }

  void sub(double x, double y) {
    this.x -= x;
    this.y -= y;
  }

  void addVector(Vector v) {
    x += v.x;
    y += v.y;
  }

  void subVector(Vector v) {
    x -= v.x;
    y -= v.y;
  }

  void scale(double s) {
    x *= s;
    y *= s;
  }

  void toIdentity() {
    x = 1.0;
    y = 1.0;
  }

  void div(double s) {
    x /= s;
    y /= s;
  }

  /// Normalize this Vector
  void normalize() {
    var len = length;
    if (len != 0.0) {
      div(len);
    }
  }

  void setDirection(double radians) {
    x = cos(radians);
    y = sin(radians);
  }

  @override
  String toString() {
    return '<${x.toStringAsFixed(3)},${y.toStringAsFixed(3)}>';
  }

  /// addVectors = [out] = [v1] + [v2]
  static void addVectors(Vector v1, Vector v2, Vector out) {
    out.x = v1.x + v2.x;
    out.y = v1.y + v2.y;
  }

  /// subVectors = [out] = [v1] - [v2]
  static void subVectors(Vector v1, Vector v2, Vector out) {
    out.x = v1.x - v2.x;
    out.y = v1.y - v2.y;
  }

  /// scaleBy = [out] = [s] * [v]
  static void scaleBy(double s, Vector v, Vector out) {
    out.x = s * v.x;
    out.y = s * v.y;
  }

  /// Distance between two vectors
  static double vectorDistance(Vector v1, Vector v2) {
    subVectors(v1, v2, _tmp);
    return _tmp.length;
  }

  /// Dot computes the dot-product between the vectors
  static double dot(Vector v1, Vector v2) {
    return v1.x * v2.x + v1.y * v2.y;
  }

  /// Angle computes the angle in radians between two vector directions
  static double angle(Vector v1, Vector v2) {
    _tmp.x = v1.x;
    _tmp.y = v1.y;

    _tmp2.x = v2.x;
    _tmp2.y = v2.y;

    _tmp.normalize();
    _tmp2.normalize();

    var angl = atan2(cross(_tmp, _tmp2), vectorDot(_tmp, _tmp2));

    if (angl.abs() < epsilon) {
      return 0.0;
    }

    return angl;
  }

  // static double angle(Vector vo) {
  //   return atan2(vo.y, vo.x);
  // }

  /// Cross computes the cross-product of two vectors (right-angles)
  static double cross(Vector v1, Vector v2) {
    return v1.x * v2.y - v1.y * v2.x;
  }

  static double vectorDot(Vector v1, Vector v2) {
    return v1.x * v2.x + v1.y * v2.y;
  }
}
