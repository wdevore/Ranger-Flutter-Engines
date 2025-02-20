import 'point.dart';

abstract class Geometry {
  bool coordsInside(double x, double y) => false;
  bool pointInside(Point p) => false;
}
