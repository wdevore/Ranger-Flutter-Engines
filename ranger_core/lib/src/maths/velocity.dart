import '../geometry/point.dart';
import 'constants.dart';
import 'vector.dart';

class Velocity {
  double magnitude = 0.0;

  double minMag = 0.0;
  double maxMag = 0.0;

  Vector direction = Vector.zero();

  bool limitMag = false;

  Velocity();

  factory Velocity.xDirection() {
    Velocity v = Velocity()
      ..direction = Vector.create(1.0, 0.0)
      ..limitMag = true;
    return v;
  }

  factory Velocity.velocity(Velocity v) {
    Velocity vel = Velocity()
      ..magnitude = v.magnitude
      ..minMag = v.minMag
      ..maxMag = v.maxMag
      ..direction = v.direction;
    return vel;
  }

  void setDirectionByAngle(double radians) => direction.setByAngle(radians);

  void setDirectionByVector(Vector v) {
    direction.x = v.x;
    direction.y = v.y;
  }

  void applyToVector(Vector point) {
    // Get actual velocity
    v1.x = direction.x * magnitude;
    v1.y = direction.y * magnitude;
    Vector.addVectors(v1, point, point);
  }

  void applyToPoint(Point point) {
    // Get actual velocity
    v1.x = direction.x * magnitude;
    v1.y = direction.y * magnitude;
    v2.x = point.x;
    v2.y = point.y;
    Vector.addVectors(v1, v2, v3);
    point.x = v3.x;
    point.y = v3.y;
  }

  @override
  String toString() {
    return '|${magnitude.toStringAsPrecision(6)}| $direction';
  }
}
