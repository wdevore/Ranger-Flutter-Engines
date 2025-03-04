import 'dart:math';

import '../geometry/point.dart';
import 'matrix4.dart';

class AffineTransform {
  static const ma = 0; // a
  static const mb = 1; // b
  static const m2 = 2; // 0
  static const m3 = 3; // 0
  static const mc = 4; // c
  static const md = 5; // d
  static const m6 = 6; // 0
  static const m7 = 7; // 0

  static const m8 = 8; // 0
  static const m9 = 9; // 0
  static const m10 = 10; // 1
  static const m11 = 11; // 0
  static const me = 12; // e
  static const mf = 13; // f
  static const m14 = 14; // 0
  static const m15 = 15; // 1

  // [a, b, 0, c, d, 0, e, f, 1]
  // m [9]float32

  // [a, b, 0, 0, c, d, 0, 0, 0, 0, 1, 0, 0, e, f, 0, 1]
  List<double> m = List.filled(16, 0.0);

  AffineTransform();

  factory AffineTransform.create() => AffineTransform();

  factory AffineTransform.identity() => AffineTransform.create()..toIdentity();

  double get a => m[ma];
  double get b => m[mb];
  double get c => m[mc];
  double get d => m[md];
  double get tx => m[me];
  double get ty => m[mf];

  set a(double v) => m[ma] = v;
  set b(double v) => m[mb] = v;
  set c(double v) => m[mc] = v;
  set d(double v) => m[md] = v;
  set tx(double v) => m[me] = v;
  set ty(double v) => m[mf] = v;

  void setByComp(double a, double b, double c, double d, double tx, double ty) {
    m[ma] = a;
    m[mb] = b;
    m[mc] = c;
    m[md] = d;
    m[me] = tx;
    m[mf] = ty;
  }

  void setByTransform(AffineTransform t) {
    m[ma] = t.a;
    m[mb] = t.b;
    m[mc] = t.c;
    m[md] = t.d;
    m[me] = t.tx;
    m[mf] = t.ty;
  }

  void setFromMatrix(Matrix4 m4) {
    m[0] = m4.e[0];
    m[1] = m4.e[1];
    m[2] = m4.e[2];
    m[3] = m4.e[3];
    m[4] = m4.e[4];
    m[5] = m4.e[5];
    m[6] = m4.e[6];
    m[7] = m4.e[7];
    m[8] = m4.e[8];
    m[9] = m4.e[9];
    m[10] = m4.e[10];
    m[11] = m4.e[11];
    m[12] = m4.e[12];
    m[13] = m4.e[13];
    m[14] = m4.e[14];
    m[15] = m4.e[15];
  }

  void transformPoint(Point p) {
    p.x = (m[ma] * p.x) + (m[mc] * p.y) + m[me];
    p.y = (m[mb] * p.x) + (m[md] * p.y) + m[mf];
  }

  void transformToPoint(Point p, Point out) {
    out.x = (m[ma] * p.x) + (m[mc] * p.y) + m[me];
    out.y = (m[mb] * p.x) + (m[md] * p.y) + m[mf];
  }

  void transformXYPoint(double x, double y, Point out) {
    out.x = (m[ma] * x) + (m[mc] * y) + m[me];
    out.y = (m[mb] * x) + (m[md] * y) + m[mf];
  }

  /// [translate] mutates/concat *this* matrix using tx,ty
  void translate(double x, double y) {
    m[me] += (m[ma] * x) + (m[mc] * y);
    m[mf] += (m[mb] * x) + (m[md] * y);
  }

  /// [makeTranslate] sets the transform to a Translate matrix
  void makeTranslate(double x, double y) {
    m[ma] = 1.0;
    m[mb] = 0.0;
    m[mc] = 0.0;
    m[md] = 1.0;
    m[me] = x;
    m[mf] = y;
  }

  void makeTranslatePoint(Point p) {
    m[ma] = 1.0;
    m[mb] = 0.0;
    m[mc] = 0.0;
    m[md] = 1.0;
    m[me] = p.x;
    m[mf] = p.y;
  }

  /// [scale] mutates *this* matrix using sx, sy
  void scale(double sx, double sy) {
    m[ma] *= sx;
    m[mb] *= sx;
    m[mc] *= sy;
    m[md] *= sy;
  }

  void makeScale(double sx, double sy) {
    m[ma] = sx;
    m[mb] = 0.0;
    m[mc] = 0.0;
    m[md] = sy;
    m[me] = 0.0;
    m[mf] = 0.0;
  }

  /// [getPsuedoScale] returns the transform's [a] component, however,
  /// this is only valid if the transform doesn't have a rotation or zoom applied.
  /// **Use it with clear understanding**.
  double getPsuedoScale() {
    return m[ma];
  }

  /// Concatinate a rotation [radians] onto this transform.
  ///
  /// Rotation is just a matter of perspective. A CW rotation can be seen as
  /// CCW depending on what you are talking about rotating. For example,
  /// if the coordinate system is thought as rotating CCW then objects are
  /// seen as rotating CW, and that is what the 2x2 matrix below represents.
  ///
  /// It is also the frame of reference we use. In this library +Y axis is downward
  ///
  ///     [cos  -sin]   object appears to rotate CW.
  ///     [sin   cos]
  ///
  /// In the matrix below the object appears to rotate CCW.
  ///
  ///     [cos  sin]
  ///     [-sin cos]
  ///
  ///     [a  c]    [cos  -sin]
  ///     [b  d]  x [sin   cos]
  ///
  /// If Y axis is downward (default for SDL and Image) then:
  /// +angle yields a CW rotation
  /// -angle yeilds a CCW rotation.
  ///
  /// else
  /// -angle yields a CW rotation
  /// +angle yeilds a CCW rotation.
  void rotate(double radians) {
    var s = sin(radians);
    var cr = cos(radians);

    // Capture value BEFORE they are modified
    var a = m[ma];
    var b = m[mb];
    var c = m[mc];
    var d = m[md];

    m[ma] = a * cr + c * s;
    m[mb] = b * cr + d * s;
    m[mc] = c * cr - a * s;
    m[md] = d * cr - b * s;
  }

  void makeRotate(double radians) {
    var s = sin(radians);
    var c = cos(radians);
    m[ma] = c;
    m[mb] = s;
    m[mc] = -s;
    m[md] = c;
    m[me] = 0.0;
    m[mf] = 0.0;
  }

  /// [multiplyPre] performs: [n] = [n] * [m]. Where [n] is output
  static void multiplyPre(AffineTransform m, AffineTransform n) {
    // Copy values BEFORE modifying them.
    var na = n.a;
    var nb = n.b;
    var nc = n.c;
    var nd = n.d;

    var ja = m.a;
    var jb = m.b;
    var jc = m.c;
    var jd = m.d;
    var mtx = m.tx;
    var mty = m.ty;

    // Now perform multiplication
    n.a = na * ja + nb * jc;
    n.b = na * jb + nb * jd;
    n.c = nc * ja + nd * jc;
    n.d = nc * jb + nd * jd;
    n.tx = (na * mtx) + (nc * m.ty) + mtx;
    n.ty = (nb * mtx) + (nd * m.ty) + mty;
  }

  /// [multiplyPost] performs: [n] = [m] * [n]. Where [n] is output
  static void multiplyPost(AffineTransform m, AffineTransform n) {
    // Copy values BEFORE modifying them.
    var na = n.a;
    var nb = n.b;
    var nc = n.c;
    var nd = n.d;
    var ntx = n.tx;
    var nty = n.ty;

    var ja = m.a;
    var jb = m.b;
    var jc = m.c;
    var jd = m.d;

    // Now perform multiplication
    n.a = ja * na + jb * nc;
    n.b = ja * nb + jb * nd;
    n.c = jc * na + jd * nc;
    n.d = jc * nb + jd * nd;
    n.tx = (ja * ntx) + (jc * n.ty) + ntx;
    n.ty = (jb * ntx) + (jd * n.ty) + nty;
  }

  /// [multiplyPost] performs: [out] = [m] * [n]
  static void multiply(
      AffineTransform m, AffineTransform n, AffineTransform out) {
    // Copy values BEFORE modifying them.
    var na = n.a;
    var nb = n.b;
    var nc = n.c;
    var nd = n.d;
    var ntx = n.tx;
    var nty = n.ty;

    var ja = m.a;
    var jb = m.b;
    var jc = m.c;
    var jd = m.d;
    var jtx = m.tx;
    var jty = m.ty;

    // Now perform multiplication
    out.a = ja * na + jb * nc;
    out.b = ja * nb + jb * nd;
    out.c = jc * na + jd * nc;
    out.d = jc * nb + jd * nd;
    out.tx = (jtx * na) + (jty * nc) + ntx;
    out.ty = (jtx * nb) + (jty * nd) + nty;
  }

  void invert() {
    // Copy values BEFORE modifying them.
    var a = m[ma];
    var b = m[mb];
    var c = m[mc];
    var d = m[md];
    var tx = m[me];
    var ty = m[mf];

    var determinant = 1.0 / (a * d - b * c);

    m[ma] = determinant * d;
    m[mb] = -determinant * b;
    m[mc] = -determinant * c;
    m[md] = determinant * a;
    m[me] = determinant * (c * ty - d * tx);
    m[mf] = determinant * (b * tx - a * ty);
  }

  void invertTo(AffineTransform out) {
    var determinant = 1.0 / (a * d - b * c);

    out.a = determinant * d;
    out.b = -determinant * b;
    out.c = -determinant * c;
    out.d = determinant * a;
    out.tx = determinant * (c * ty - d * tx);
    out.ty = determinant * (b * tx - a * ty);
  }

  /// [transpose] c and d elements.
  ///
  /// Converts either from or to pre or post multiplication.
  ///
  ///         a c
  ///         b d
  ///     to
  ///         a b
  ///         c d
  void transpose() {
    var c = m[mc];
    m[mc] = m[mb];
    m[mb] = c;
  }

  @override
  String toString() {
    String s = '';
    s += '|${a.toStringAsPrecision((5))}';
    s += ',${c.toStringAsPrecision((5))}';
    s += ',${tx.toStringAsPrecision((5))}|\n';
    s += '|${b.toStringAsPrecision((5))}';
    s += ',${d.toStringAsPrecision((5))}';
    s += ',${ty.toStringAsPrecision((5))}|\n';
    return s;
  }

  String toString4x4() {
    String s = '';
    // | ma mc m8  me  |
    // | mb md m9  mf  |
    // | m2 m6 m10 m14 |
    // | m3 m7 m11 m15 |

    s += '|${a.toStringAsPrecision((5))}';
    s += ',${c.toStringAsPrecision((5))}';
    s += ',${m[m8].toStringAsPrecision((5))}';
    s += ',${tx.toStringAsPrecision((5))}|\n';

    s += '|${b.toStringAsPrecision((5))}';
    s += ',${d.toStringAsPrecision((5))}';
    s += ',${m[m9].toStringAsPrecision((5))}';
    s += ',${ty.toStringAsPrecision((5))}|\n';

    s += '|${m[m2].toStringAsPrecision((5))}';
    s += ',${m[m6].toStringAsPrecision((5))}';
    s += ',${m[m10].toStringAsPrecision((5))}';
    s += ',${m[m14].toStringAsPrecision((5))}|\n';

    s += '|${m[m3].toStringAsPrecision((5))}';
    s += ',${m[m7].toStringAsPrecision((5))}';
    s += ',${m[m11].toStringAsPrecision((5))}';
    s += ',${m[m15].toStringAsPrecision((5))}|\n';
    return s;
  }

  // | 1 0 0 0 |     | a c 0 e |  | ma mc m8  me  |
  // | 0 1 0 0 | ==> | b d 0 f |  | mb md m9  mf  |
  // | 0 0 1 0 |     | 0 0 1 0 |  | m2 m6 m10 m14 |
  // | 0 0 0 1 |     | 0 0 0 1 |  | m3 m7 m11 m15 |
  void toIdentity() {
    m[ma] = 1.0;
    m[mb] = 0.0;
    m[m2] = 0.0;
    m[m3] = 0.0;

    m[mc] = 0.0;
    m[md] = 1.0;
    m[m6] = 0.0;
    m[m7] = 0.0;

    m[m8] = 0.0;
    m[m9] = 0.0;
    m[m10] = 1.0;
    m[m11] = 0.0;

    m[me] = 0.0;
    m[mf] = 0.0;
    m[m14] = 0.0;
    m[m15] = 1.0;
  }
}
