import 'dart:convert';

import 'char_vectors.dart';

class VectorFont {
  // Map of vector characters
  Map<String, CharVectors> characters = {};

  RegExp labelExpr = RegExp(r'[A-Za-z]{1,1}');
  RegExp verticesExpr = RegExp(r'([0-9.-]+),([0-9.-]+)');

  VectorFont();

  factory VectorFont.create(List<String> data) {
    VectorFont vf = VectorFont().._loadFont(data);

    return vf;
  }

  void _loadFont(List<String> data) {
    String mapChar = '';
    int index = 0;
    String matchData = '';
    late CharVectors cv;

    while (true) {
      // Try to read a char label
      String label = data.elementAt(index++);
      RegExpMatch? match = labelExpr.firstMatch(label);
      if (match != null) {
        if (label == 'EOF') return;
        mapChar = match[0]!;
        cv = CharVectors()..label = mapChar;
      }

      // Try to read vertices until EOC
      matchData = data.elementAt(index++);
      while (matchData != 'EOC') {
        cv.newPath();
        for (var coordMatch in verticesExpr.allMatches(matchData)) {
          cv.addVertex(coordMatch);
        }
        matchData = data.elementAt(index++);
      }

      characters[cv.label] = cv;
    }
  }

  static List<String> loadDefaultVectorFont({String root = ''}) {
    // var pathJoin = p.join(
    //   Directory.current.path,
    //   '$root/extras/assets/vector_font.data',
    // );

    // final File file = File(pathJoin);
    // List<String> data = file.readAsLinesSync();

    List<String> data = LineSplitter.split(fontData).toList();

    return data;
  }

  static const String fontData = """
A
-0.25,0.5  0.0,-0.5   0.25,0.5
-0.125,0.0  0.125,0.0
EOC
a
-0.25,-0.125 -0.125,-0.25 -0.0625,-0.25 0.1875,-0.1875 0.1875,0.0625 -0.1805,0.0625 -0.3125,0.255 -0.145,0.5 0.125,0.395 0.1875,0.25 0.1875,0.0625
0.1875,0.25 0.1875,0.375 0.375,0.45
EOC
B
-0.25,0.5 -0.25,0.0 -0.25,-0.5 0.125,-0.5 0.360,-0.25 0.125,0.0 0.360,0.25 0.125,0.5 -0.25,0.5
0.125,0.0 -0.25,0.0
EOC
0
-0.125,0.375 -0.25,0.25 -0.25,-0.185 -0.105,-0.35 0.105,-0.35 0.25,-0.185 0.25,0.25 0.125,0.375
-0.185,0.375 -0.175,-0.25
EOC
1
-0.25,-0.145 -0.125,-0.20 0.065,-0.22 0.065,0.45
-0.27,0.45 0.27,0.45
EOC
2
-0.185,-0.25 -0.125,-0.28 0.125,-0.28 0.25,-0.125 0.105,0.125 -0.145,0.3125 -0.195,0.45 0.35,0.45
EOC
3
-0.23,-0.125 -0.135,-0.29 0.135,-0.29 0.23,-0.125 0.0625,0.06 -0.0625,0.120 0.0625,0.25 0.25,0.0625 0.125,0.43 -0.125,0.43 -0.125,0.0625
EOC
4
0.135,0.25 -0.25,0.25 0.125,-0.25 0.125,-0.25 0.135,0.5
EOC
5
0.25,-0.28 -0.186,-0.28 -0.23,0.355 0.0,0.0 0.25,0.125 0.23,0.325 0.0,0.45 -0.225,0.375 -0.24,0.20
EOC
6
0.2,-0.155 0.125,-0.3 -0.105,-0.3 -0.23,-0.155 -0.25,0.125 -0.0625,0.375 0.0,0.45 0.355,0.375 0.125,0.375 0.125,0.375 -0.25,0.125
EOC
7
-0.0625,0.5 0.0,0.20 0.125,-0.110 0.27,-0.25 -0.27,-0.25
EOC
8
0.0,0.45 -0.2,0.375 -0.2,0.125 0.115,0.0675 0.2,-0.125 0.145,-0.30 0.0,-0.35 -0.145,-0.30 -0.2,-0.125 -0.115,0.0675 0.2,0.125 0.2,0.375 0.0,0.45
EOC
9
-0.25,0.30 -0.105,0.45 0.120,0.35 0.22,0.25 0.22,-0.0625 0.125,-0.26 -0.0625,-0.26 -0.25,-0.355 -0.25,0.105 -0.105,0.20 0.135,0.125 0.22,-0.0625
EOC
.
-0.0625,0.40 0.0625,0.40 0.0625,0.120 -0.0625,0.120
EOC
-
-0.25, 0.0 0.25, 0.0
EOC
EOF
""";
}
