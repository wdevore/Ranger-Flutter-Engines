import 'dart:convert';

import 'package:ranger_core/src/extras/fonts/vector/char_vectors.dart';

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
EOF
""";
}
