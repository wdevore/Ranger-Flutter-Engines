import 'dart:math';

class CharVertex {
  double x = 0.0;
  double y = 0.0;
}

class CharVectors {
  String label = '';

  // A list of paths
  List<List<CharVertex>> paths = [];
  late List<CharVertex> currentPath;
  double minX = double.infinity;
  double maxX = double.negativeInfinity;
  double width = 0.0;

  double minY = double.infinity;
  double maxY = double.negativeInfinity;
  double height = 0.0;

  CharVectors();

  factory CharVectors.create(String label) => CharVectors()..label = label;

  void newPath() {
    currentPath = <CharVertex>[];
    paths.add(currentPath);
  }

  void addVertex(RegExpMatch vertex) {
    double xCoord = double.parse(vertex[1]!);
    double yCoord = double.parse(vertex[2]!);

    minX = min(minX, xCoord);
    maxX = max(maxX, xCoord);

    width = (maxX - minX).abs();

    minY = min(minY, yCoord);
    maxY = max(maxY, yCoord);
    height = (maxY - minY).abs();

    CharVertex cv = CharVertex()
      ..x = xCoord
      ..y = yCoord;

    currentPath.add(cv);
  }

  @override
  String toString() {
    return '$label || ${paths.length}';
  }
}
