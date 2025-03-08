import 'affinetransform.dart';
import 'vector.dart';

class ZoomTransform {
  // An optional (occasionally used) translation.
  late Vector position;

  // The zoom factor generally incremented in small steps.
  // For example, 0.1
  late Vector _scale;

  // The focal point where zooming occurs
  late Vector zoomAt;

  // A "running" accumulating transform
  late AffineTransform accTransform;

  // A transform that includes position translation.
  late AffineTransform _transform;

  ZoomTransform();

  factory ZoomTransform.create() {
    ZoomTransform z = ZoomTransform()
      ..position = Vector.zero()
      .._scale = Vector.create(1.0, 1.0)
      ..zoomAt = Vector.zero()
      ..accTransform = AffineTransform.identity()
      .._transform = AffineTransform.identity();

    return z;
  }

  /// [transform] updates and returns the internal transform.
  AffineTransform get transform {
    update();
    return _transform;
  }

  /// [update] modifies the internal transform state based on current values.
  void update() {
    // Accumulate zoom transformations.
    // acc_transform is an intermediate accumulative matrix used for tracking
    // the current zoom target.
    accTransform.translate(zoomAt.x, zoomAt.y);
    accTransform.scale(_scale.x, _scale.y);
    // print('_scale: $_scale | $zoomAt');
    accTransform.translate(-zoomAt.x, -zoomAt.y);

    // We reset Scale because acc_transform is accumulative and has "captured"
    // the information.
    _scale.toIdentity();

    // We want to leave acc_transform solely responsible for zooming.
    // "transform" is the final matrix.
    _transform.setByTransform(accTransform);

    // Tack on translation. Note: we don't append it, but concat it into a
    // separate matrix.
    _transform.translate(position.x, position.y);
  }

  /// [setPosition] is an absolute position. Typically you would use TranslateBy.
  void setPosition(double x, double y) {
    position
      ..x = x
      ..y = y;
  }

  /// [zoomBy] performs a relative zoom based on the current scale/zoom.
  void zoomBy(double dx, double dy) {
    _scale.add(dx, dy);
  }

  /// [translateBy] is a relative positional translation.
  void translateBy(double dx, double dy) {
    position.add(dx, dy);
  }

  double get scale => _scale.x;

  double get psuedoScale => accTransform.getPsuedoScale();

  /// [scale] sets the scale based on the current scale value making
  /// this a relative scale.
  set scale(double scale) {
    update();

    // We use dimensional analysis to set the scale. Remember we can't
    // just set the scale absolutely because acc_transform is an accumulating
    // matrix. We have to take its current value and compute a new value based
    // on the passed in value.

    // Also, I can use acc_transform.a because I don't allow rotations for zooms,
    // so the diagonal components correctly represent the matrix's current scale.
    // And because I only perform uniform scaling I can safely use just the "a"
    // element.
    double scaleFactor = scale / accTransform.getPsuedoScale();

    _scale.scale(scaleFactor);
  }

  void setAt(double x, double y) {
    zoomAt
      ..x = x
      ..y = y;
  }
}
