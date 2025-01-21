import 'package:flutter_test/flutter_test.dart';
import 'package:ranger_handcrafted/maths/vector3.dart';

void testVector3() {
  group('Vector3', () {
    test('Add', () {
      var am = Vector3.create3(2.0, 2.0, 2.0);
      am.add3(2.5, 1.5, 1.0);
      expect(am.x == 4.5, isTrue);
      expect(am.y == 3.5, isTrue);
      expect(am.z == 3.0, isTrue);
    });

    test('Scale', () {
      var am = Vector3.create3(2.0, 2.0, 2.0);
      am.uniformScaleBy(2.0);
      expect(am.x == 4.0, isTrue);
      expect(am.y == 4.0, isTrue);
      expect(am.z == 4.0, isTrue);
    });

    test('Epsilon equal', () {
      var am = Vector3.create3(2.0, 2.0, 2.0);
      var bm = Vector3.create3(2.0000000001, 2.0, 2.0);
      bool equal = am.epsilonEq(bm);
      expect(equal, isTrue);
    });

    test('Epsilon !equal', () {
      var am = Vector3.create3(2.0, 2.0, 2.0);
      var bm = Vector3.create3(2.0001, 2.0, 2.0);
      bool equal = am.epsilonEq(bm);
      expect(equal, isFalse);
    });
  });
}
