import 'dart:math';

import 'vector3.dart';
import 'affinetransform.dart';

//    2x3          3x3            4x4         OpenGL Array Index      M(Cell/Row)
// | a c e |    | a c e |      | a c 0 e |      |00 04 08 12|     |M00 M01 M02 M03|
// | b d f |    | b d f |  =>  | b d 0 f | ==>  |01 05 09 13| ==> |M10 M11 M12 M13|
// 	            | 0 0 1 |      | 0 0 1 0 |      |02 06 10 14|     |M20 M21 M22 M23|
// 	                           | 0 0 0 1 |      |03 07 11 15|     |M30 M31 M32 M33|
class Matrix4 {
  // Array indices
  // M00 XX: Typically the unrotated X component for scaling, also the cosine of the
  // angle when rotated on the Y and/or Z axis. On
  // Vector3 multiplication this value is multiplied with the source X component
  // and added to the target X component.
  static const m00 = 0;
  // M01 XY: Typically the negative sine of the angle when rotated on the Z axis.
  // On Vector3 multiplication this value is multiplied
  // with the source Y component and added to the target X component.
  static const m01 = 4;
  // M02 XZ: Typically the sine of the angle when rotated on the Y axis.
  // On Vector3 multiplication this value is multiplied with the
  // source Z component and added to the target X component.
  static const m02 = 8;
  // M03 XW: Typically the translation of the X component.
  // On Vector3 multiplication this value is added to the target X component.
  static const m03 = 12;

  // M10 YX: Typically the sine of the angle when rotated on the Z axis.
  // On Vector3 multiplication this value is multiplied with the
  // source X component and added to the target Y component.
  static const m10 = 1;
  // M11 YY: Typically the unrotated Y component for scaling, also the cosine
  // of the angle when rotated on the X and/or Z axis. On
  // Vector3 multiplication this value is multiplied with the source Y
  // component and added to the target Y component.
  static const m11 = 5;
  // M12 YZ: Typically the negative sine of the angle when rotated on the X axis.
  // On Vector3 multiplication this value is multiplied
  // with the source Z component and added to the target Y component.
  static const m12 = 9;
  // M13 YW: Typically the translation of the Y component.
  // On Vector3 multiplication this value is added to the target Y component.
  static const m13 = 13;

  // M20 ZX: Typically the negative sine of the angle when rotated on the Y axis.
  // On Vector3 multiplication this value is multiplied
  // with the source X component and added to the target Z component.
  static const m20 = 2;
  // M21 ZY: Typical the sine of the angle when rotated on the X axis.
  // On Vector3 multiplication this value is multiplied with the
  // source Y component and added to the target Z component.
  static const m21 = 6;
  // M22 ZZ: Typically the unrotated Z component for scaling, also the cosine of the
  // angle when rotated on the X and/or Y axis.
  // On Vector3 multiplication this value is multiplied with the source Z component
  // and added to the target Z component.
  static const m22 = 10;
  // M23 ZW: Typically the translation of the Z component.
  // On Vector3 multiplication this value is added to the target Z component.
  static const m23 = 14;

  // M30 WX: Typically the value zero. On Vector3 multiplication this value is ignored.
  static const m30 = 3;
  // M31 WY: Typically the value zero. On Vector3 multiplication this value is ignored.
  static const m31 = 7;
  // M32 WZ: Typically the value zero. On Vector3 multiplication this value is ignored.
  static const m32 = 11;
  // M33 WW: Typically the value one. On Vector3 multiplication this value is ignored.
  static const m33 = 15;

  // Linear representation of matrix
  final List<double> e = List.filled(16, 0.0);

  // Temporary matricies for multiplication
  late Matrix4 _tempM0;
  late Matrix4 _mulM;

  Matrix4();

  factory Matrix4.create() {
    Matrix4 m = Matrix4()
      .._tempM0 = Matrix4()
      ..toIdentity()
      .._mulM = Matrix4()
      ..toIdentity();
    return m;
  }

  factory Matrix4.identity() => Matrix4()..toIdentity();

  void toIdentity() {
    e[m00] = 1.0;
    e[m01] = 0.0;
    e[m02] = 0.0;
    e[m03] = 0.0;

    e[m10] = 0.0;
    e[m11] = 1.0;
    e[m12] = 0.0;
    e[m13] = 0.0;

    e[m20] = 0.0;
    e[m21] = 0.0;
    e[m22] = 1.0;
    e[m23] = 0.0;

    e[m30] = 0.0;
    e[m31] = 0.0;
    e[m32] = 0.0;
    e[m33] = 1.0;
  }

  void setFrom(Matrix4 m) {
    e[m00] = e[m00];
    e[m01] = e[m01];
    e[m02] = e[m02];
    e[m03] = e[m03];

    e[m10] = e[m10];
    e[m11] = e[m11];
    e[m12] = e[m12];
    e[m13] = e[m13];

    e[m20] = e[m20];
    e[m21] = e[m21];
    e[m22] = e[m22];
    e[m23] = e[m23];

    e[m30] = e[m30];
    e[m31] = e[m31];
    e[m32] = e[m32];
    e[m33] = e[m33];
  }

  // --------------------------------------------------------------------------
  // Translation
  // --------------------------------------------------------------------------
  /// [translateBy] adds a translational component to the matrix in the 4th column.
  /// The other columns are unmodified.
  void translate(Vector3 v) {
    translateBy3Comps(v.x, v.y, v.z);
  }

  /// [translateBy3Comps] adds a translational component to the matrix in the 4th column.
  /// The other columns are unmodified.
  void translateBy3Comps(double x, double y, double z) {
    var t = _tempM0;
    t.e[m00] = 1.0;
    t.e[m01] = 0.0;
    t.e[m02] = 0.0;
    t.e[m03] = x;
    t.e[m10] = 0.0;
    t.e[m11] = 1.0;
    t.e[m12] = 0.0;
    t.e[m13] = y;
    t.e[m20] = 0.0;
    t.e[m21] = 0.0;
    t.e[m22] = 1.0;
    t.e[m23] = z;
    t.e[m30] = 0.0;
    t.e[m31] = 0.0;
    t.e[m32] = 0.0;
    t.e[m33] = 1.0;

    multiply4(this, t, _mulM.e);
    setFrom(_mulM);
  }

  /// [setTranslateByVector] resets the matrix to Identity and then
  /// sets translational components in the 4th column.
  void setTranslateUsingVector(Vector3 v) {
    toIdentity();
    e[m03] = v.x;
    e[m13] = v.y;
    e[m23] = v.z;
  }

  /// [setToTranslate] resets the matrix to Identity and then
  /// sets translational components in the 4th column.
  void setToTranslate(double x, double y, double z) {
    toIdentity();
    e[m03] = x;
    e[m13] = y;
    e[m23] = z;
  }

  /// [getTranslation] returns the translational components in 'out' Vector3 field.
  void getTranslation(Vector3 out) {
    out.x = e[m03];
    out.y = e[m13];
    out.z = e[m23];
  }

  // --------------------------------------------------------------------------
  // Rotation
  // --------------------------------------------------------------------------
  /// [setRotation] set a rotation matrix about Z axis. [angle] is specified
  /// in radians.
  ///
  ///      [  m00  m01   _    _   ]
  ///      [  m10  m11   _    _   ]
  ///      [   _    _    _    _   ]
  ///      [   _    _    _    _   ]
  void setRotation(double angle) {
    if (angle == 0.0) return;

    toIdentity();

    // Column major
    var c = cos(angle);
    var s = sin(angle);

    e[m00] = c;
    e[m01] = -s;
    e[m10] = s;
    e[m11] = c;
  }

  /// [rotate] post-multiplies this matrix with a (counter-clockwise) rotation
  /// matrix whose [angle] is specified in radians.
  /// Used for continual concatination of rotations.
  ///
  ///      [m00  m01  m02  m03]
  ///      [m10  m11  m12  m13]
  ///      [m20  m21  m22  m23]
  ///      [m30  m31  m32  m33]
  void rotate(double angle) {
    if (angle == 0.0) return;

    // Column major
    var c = cos(angle);
    var s = sin(angle);

    var t = _tempM0;
    t.e[m00] = c;
    t.e[m01] = -s;
    t.e[m02] = 0.0;
    t.e[m03] = 0.0;
    t.e[m10] = s;
    t.e[m11] = c;
    t.e[m12] = 0.0;
    t.e[m13] = 0.0;
    t.e[m20] = 0.0;
    t.e[m21] = 0.0;
    t.e[m22] = 1.0;
    t.e[m23] = 0.0;
    t.e[m30] = 0.0;
    t.e[m31] = 0.0;
    t.e[m32] = 0.0;
    t.e[m33] = 1.0;

    multiply4(this, t, _mulM.e);
    setFrom(_mulM);
  }

  // --------------------------------------------------------------------------
  // Scale
  // --------------------------------------------------------------------------
  /// [setScale] sets the scale components of an identity matrix and captures
  /// scale values into Scale property.
  void setScale(Vector3 v) {
    toIdentity();
    e[m00] = v.x;
    e[m11] = v.y;
    e[m22] = v.z;
  }

  /// [setScale3Comp] sets the scale components of an identity matrix and captures
  /// scale values into Scale property.
  void setScale3Comp(double sx, double sy, double sz) {
    toIdentity();

    e[m00] = sx;
    e[m11] = sy;
    e[m22] = sz;
  }

  /// [setScale2Comp] sets the scale components of an identity matrix and captures
  /// scale values into Scale property where Z component = 1.0.
  void setScale2Comp(double sx, double sy) {
    toIdentity();

    e[m00] = sx;
    e[m11] = sy;
    e[m22] = 1.0;
  }

  /// [scaleByComp] scales the scale components.
  void scaleByComp(double sx, double sy, double sz) {
    var t = _tempM0;

    t.e[m00] = sx;
    t.e[m01] = 0;
    t.e[m02] = 0;
    t.e[m03] = 0;
    t.e[m10] = 0;
    t.e[m11] = sy;
    t.e[m12] = 0;
    t.e[m13] = 0;
    t.e[m20] = 0;
    t.e[m21] = 0;
    t.e[m22] = sz;
    t.e[m23] = 0;
    t.e[m30] = 0;
    t.e[m31] = 0;
    t.e[m32] = 0;
    t.e[m33] = 1;

    multiply4(this, t, _mulM.e);
    setFrom(_mulM);
  }

  /// This is a rough approximation under certain conditions. Use it with
  /// extreme caution!
  double getPsuedoScale() {
    return e[m00];
  }

  // --------------------------------------------------------------------------
  // Transforms
  // --------------------------------------------------------------------------
  void transformVertices3D(List<double> inv, List<double> out) {
    for (var i = 0; i < inv.length; i += 3) {
      var x = inv[i];
      var y = inv[i + 1];
      var z = inv[i + 2];

      // http://www.c-jump.com/bcc/common/Talk3/Math/Matrices/Matrices.html
      out[i] = e[m00] * x + e[m01] * y + e[m02] * z + e[m03]; // x
      out[i + 1] = e[m10] * x + e[m11] * y + e[m12] * z + e[m13]; // y
      out[i + 2] = 0.0; // e[m20]*x + e[m21]*y + e[m22]*z + e[m23] // z
    }
  }

  void transformVector(Vector3 v, Vector3 out) {
    out.x = e[m00] * v.x + e[m01] * v.y + e[m02] * v.z + e[m03]; // x
    out.y = e[m10] * v.x + e[m11] * v.y + e[m12] * v.z + e[m13]; // y
    out.z = 0.0;
  }

  // --------------------------------------------------------------------------
  // Matrix methods
  // --------------------------------------------------------------------------
  void setFromAffine(AffineTransform src) {
    var s = src.m;
    e[0] = s[0];
    e[1] = s[1];
    e[2] = s[2];
    e[3] = s[3];
    e[4] = s[4];
    e[5] = s[5];
    e[6] = s[6];
    e[7] = s[7];
    e[8] = s[8];
    e[9] = s[9];
    e[10] = s[10];
    e[11] = s[11];
    e[12] = s[12];
    e[13] = s[13];
    e[14] = s[14];
    e[15] = s[15];
  }

  static void multiply4(Matrix4 a, Matrix4 b, List<double> out) {
    out[Matrix4.m00] = a.e[Matrix4.m00] * b.e[Matrix4.m00] +
        a.e[Matrix4.m01] * b.e[Matrix4.m10] +
        a.e[Matrix4.m02] * b.e[Matrix4.m20] +
        a.e[Matrix4.m03] * b.e[Matrix4.m30];
    out[Matrix4.m01] = a.e[Matrix4.m00] * b.e[Matrix4.m01] +
        a.e[Matrix4.m01] * b.e[Matrix4.m11] +
        a.e[Matrix4.m02] * b.e[Matrix4.m21] +
        a.e[Matrix4.m03] * b.e[Matrix4.m31];
    out[Matrix4.m02] = a.e[Matrix4.m00] * b.e[Matrix4.m02] +
        a.e[Matrix4.m01] * b.e[Matrix4.m12] +
        a.e[Matrix4.m02] * b.e[Matrix4.m22] +
        a.e[Matrix4.m03] * b.e[Matrix4.m32];
    out[Matrix4.m03] = a.e[Matrix4.m00] * b.e[Matrix4.m03] +
        a.e[Matrix4.m01] * b.e[Matrix4.m13] +
        a.e[Matrix4.m02] * b.e[Matrix4.m23] +
        a.e[Matrix4.m03] * b.e[Matrix4.m33];
    out[Matrix4.m10] = a.e[Matrix4.m10] * b.e[Matrix4.m00] +
        a.e[Matrix4.m11] * b.e[Matrix4.m10] +
        a.e[Matrix4.m12] * b.e[Matrix4.m20] +
        a.e[Matrix4.m13] * b.e[Matrix4.m30];
    out[Matrix4.m11] = a.e[Matrix4.m10] * b.e[Matrix4.m01] +
        a.e[Matrix4.m11] * b.e[Matrix4.m11] +
        a.e[Matrix4.m12] * b.e[Matrix4.m21] +
        a.e[Matrix4.m13] * b.e[Matrix4.m31];
    out[Matrix4.m12] = a.e[Matrix4.m10] * b.e[Matrix4.m02] +
        a.e[Matrix4.m11] * b.e[Matrix4.m12] +
        a.e[Matrix4.m12] * b.e[Matrix4.m22] +
        a.e[Matrix4.m13] * b.e[Matrix4.m32];
    out[Matrix4.m13] = a.e[Matrix4.m10] * b.e[Matrix4.m03] +
        a.e[Matrix4.m11] * b.e[Matrix4.m13] +
        a.e[Matrix4.m12] * b.e[Matrix4.m23] +
        a.e[Matrix4.m13] * b.e[Matrix4.m33];
    out[Matrix4.m20] = a.e[Matrix4.m20] * b.e[Matrix4.m00] +
        a.e[Matrix4.m21] * b.e[Matrix4.m10] +
        a.e[Matrix4.m22] * b.e[Matrix4.m20] +
        a.e[Matrix4.m23] * b.e[Matrix4.m30];
    out[Matrix4.m21] = a.e[Matrix4.m20] * b.e[Matrix4.m01] +
        a.e[Matrix4.m21] * b.e[Matrix4.m11] +
        a.e[Matrix4.m22] * b.e[Matrix4.m21] +
        a.e[Matrix4.m23] * b.e[Matrix4.m31];
    out[Matrix4.m22] = a.e[Matrix4.m20] * b.e[Matrix4.m02] +
        a.e[Matrix4.m21] * b.e[Matrix4.m12] +
        a.e[Matrix4.m22] * b.e[Matrix4.m22] +
        a.e[Matrix4.m23] * b.e[Matrix4.m32];
    out[Matrix4.m23] = a.e[Matrix4.m20] * b.e[Matrix4.m03] +
        a.e[Matrix4.m21] * b.e[Matrix4.m13] +
        a.e[Matrix4.m22] * b.e[Matrix4.m23] +
        a.e[Matrix4.m23] * b.e[Matrix4.m33];
    out[Matrix4.m30] = a.e[Matrix4.m30] * b.e[Matrix4.m00] +
        a.e[Matrix4.m31] * b.e[Matrix4.m10] +
        a.e[Matrix4.m32] * b.e[Matrix4.m20] +
        a.e[Matrix4.m33] * b.e[Matrix4.m30];
    out[Matrix4.m31] = a.e[Matrix4.m30] * b.e[Matrix4.m01] +
        a.e[Matrix4.m31] * b.e[Matrix4.m11] +
        a.e[Matrix4.m32] * b.e[Matrix4.m21] +
        a.e[Matrix4.m33] * b.e[Matrix4.m31];
    out[Matrix4.m32] = a.e[Matrix4.m30] * b.e[Matrix4.m02] +
        a.e[Matrix4.m31] * b.e[Matrix4.m12] +
        a.e[Matrix4.m32] * b.e[Matrix4.m22] +
        a.e[Matrix4.m33] * b.e[Matrix4.m32];
    out[Matrix4.m33] = a.e[Matrix4.m30] * b.e[Matrix4.m03] +
        a.e[Matrix4.m31] * b.e[Matrix4.m13] +
        a.e[Matrix4.m32] * b.e[Matrix4.m23] +
        a.e[Matrix4.m33] * b.e[Matrix4.m33];
  }

// Multiply4 multiplies a * b and places result into 'out', (i.e. out = a * b)
  static void multiplyM4(Matrix4 a, Matrix4 b, Matrix4 out) {
    multiply4(a, b, out.e);
  }

  @override
  String toString() {
    String s = '';
    //      [m00  m01  m02  m03]
    //      [m10  m11  m12  m13]
    //      [m20  m21  m22  m23]
    //      [m30  m31  m32  m33]

    s += '|${e[m00].toStringAsPrecision((5))}';
    s += ',${e[m01].toStringAsPrecision((5))}';
    s += ',${e[m02].toStringAsPrecision((5))}';
    s += ',${e[m03].toStringAsPrecision((5))}|\n';

    s += '|${e[m10].toStringAsPrecision((5))}';
    s += ',${e[m11].toStringAsPrecision((5))}';
    s += ',${e[m12].toStringAsPrecision((5))}';
    s += ',${e[m13].toStringAsPrecision((5))}|\n';

    s += '|${e[m20].toStringAsPrecision((5))}';
    s += ',${e[m21].toStringAsPrecision((5))}';
    s += ',${e[m22].toStringAsPrecision((5))}';
    s += ',${e[m23].toStringAsPrecision((5))}|\n';

    s += '|${e[m30].toStringAsPrecision((5))}';
    s += ',${e[m31].toStringAsPrecision((5))}';
    s += ',${e[m32].toStringAsPrecision((5))}';
    s += ',${e[m33].toStringAsPrecision((5))}|\n';

    return s;
  }
}
