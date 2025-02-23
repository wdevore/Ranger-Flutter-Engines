import 'dart:ui';

import 'package:ranger_core/ranger_core.dart';
import 'package:test/test.dart';

void testFonts() {
  group('Fonts', () {
    test('Parser', () {
      List<String> data = VectorFont.loadDefaultVectorFont();
      VectorFont vf = VectorFont.create(data);
      Path path = StaticVectorText.buildPath('ABBa', vf);

      // expect(
      //   message == '',
      //   isTrue,
      // );
    });
  });
}
