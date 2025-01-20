import '../geometry/point.dart';
import '../maths/affinetransform.dart';

mixin Transform {
  late Point position;
  double rotation = 0.0;
  late Point scale;

  late AffineTransform aft;
  late AffineTransform inverse;

  void initializeTransform() {
    position = Point.create();
    scale = Point.createXY(1.0, 1.0);

    aft = AffineTransform.identity();
    inverse = AffineTransform.identity();
  }

  /// [calcFilteredTransform] performs a filter transform calculation.
  void calcFilteredTransform(bool excludeTranslation, bool excludeRotation,
      bool excludeScale, AffineTransform aft) {
    aft.toIdentity();

    if (!excludeTranslation) {
      aft.makeTranslate(position.x, position.y);
    }

    if (!excludeRotation && rotation != 0.0) {
      aft.rotate(rotation);
    }

    if (!excludeScale && (scale.x != 0.0 || scale.y != 0.0)) {
      aft.scale(scale.x, scale.y);
    }
  }
}
