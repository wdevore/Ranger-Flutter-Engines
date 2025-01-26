class Point {
  double x = 0.0;
  double y = 0.0;

  Point();

  factory Point.create() => Point();

  factory Point.createXY(double x, double y) => Point()
    ..x = x
    ..y = y;
}
