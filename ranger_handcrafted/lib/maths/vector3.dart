import 'dart:math';

import 'constants.dart';
import 'matrix4.dart';

class Vector3 {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  Vector3();

  factory Vector3.create() => Vector3();

  factory Vector3.create3(double x, double y, double z) {
    Vector3 v = Vector3()
      ..x = x
      ..y = y
      ..z = z;

    return v;
  }

  /// Create vector setting z = 0.0
  factory Vector3.create2(double x, double y) {
    Vector3 v = Vector3()
      ..x = x
      ..y = y
      ..z = 0.0;

    return v;
  }

  factory Vector3.clone(Vector3 v) {
    Vector3 v3 = Vector3()
      ..x = v.x
      ..y = v.y
      ..z = v.z;

    return v3;
  }

  void setFrom(Vector3 v) {
    x = v.x;
    y = v.y;
    z = v.z;
  }

  void add(Vector3 v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }

  void add3(double x, double y, double z) {
    this.x += x;
    this.y += y;
    this.z += z;
  }

  void sub(Vector3 v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }

  void uniformScaleBy(double s) {
    x *= s;
    y *= s;
    z *= s;
  }

  /// z component is not scaled
  void nonUniformScale2By(double sx, double sy) {
    x *= sx;
    y *= sy;
  }

  void nonUniformScale3By(double sx, double sy, double sz) {
    x *= sx;
    y *= sy;
    z *= sz;
  }

  /// mulAdd scales and adds [v] to this vector
  void mulAdd(Vector3 v, double scalar) {
    x += v.x * scalar;
    y += v.y * scalar;
    z += v.z * scalar;
  }

  double get length => sqrt(x * x + y * y + z * z);

  double get lengthSqr => x * x + y * y + z * z;

  /// Not really useful
  bool eq(Vector3 other) {
    return x == other.x && y == other.y && z == other.z;
  }

  /// Preferred usage
  bool epsilonEq(Vector3 other) {
    return ((x - other.x).abs() <= epsilon) &&
        ((y - other.y).abs() <= epsilon) &&
        ((z - other.z).abs() <= epsilon);
  }

  /// [distance] finds the euclidean distance between the two specified
  /// vectors
  double distance(Vector3 v) {
    var a = v.x - x;
    var b = v.y - y;
    var c = v.z - z;

    return sqrt(a * a + b * b + c * c);
  }

  /// [distanceSquared] finds the euclidean distance between the two specified
  /// vectors squared
  double distanceSquared(Vector3 v) {
    var a = v.x - x;
    var b = v.y - y;
    var c = v.z - z;

    return a * a + b * b + c * c;
  }

  /// [dot] returns the product between the two vectors
  double dot(Vector3 v) {
    return x * v.x + y * v.y + z * v.z;
  }

  /// Cross sets this vector to the cross product between it and the other vector.
  void cross(Vector3 v) {
    x = y * v.z - z * v.y;
    y = z * v.x - x * v.z;
    z = x * v.y - y * v.x;
  }

  // --------------------------------------------------------------------------
  // Transforms
  // --------------------------------------------------------------------------
  /// [mul] left-multiplies the vector by the given matrix,
  /// assuming the fourth (w) component of the vector is 1.
  ///
  ///     [M00 M01 M02 M03]   [x]
  ///     [M10 M11 M12 M13] x [y]
  ///     [M20 M21 M22 M23]   [z]
  ///     [M30 M31 M32 M33]   [1]  <-- w
  void mul(Matrix4 m) {
    x = x * m.e[Matrix4.m00] +
        y * m.e[Matrix4.m01] +
        z * m.e[Matrix4.m02] +
        m.e[Matrix4.m03];
    y = x * m.e[Matrix4.m10] +
        y * m.e[Matrix4.m11] +
        z * m.e[Matrix4.m12] +
        m.e[Matrix4.m13];
    z = x * m.e[Matrix4.m20] +
        y * m.e[Matrix4.m21] +
        z * m.e[Matrix4.m22] +
        m.e[Matrix4.m23];
  }

  @override
  String toString() {
    String s = '';

    s += '<${x.toStringAsPrecision((5))}';
    s += ',${y.toStringAsPrecision((5))}';
    s += ',${z.toStringAsPrecision((5))}>\n';

    return s;
  }
}
