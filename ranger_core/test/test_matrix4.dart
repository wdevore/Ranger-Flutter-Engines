import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:ranger_core/src/maths/constants.dart';
import 'package:ranger_core/src/maths/matrix4.dart';
import 'package:ranger_core/src/maths/vector3.dart';
import 'package:test/test.dart';

void testMatrix4() {
  group('Matrix4', () {
    test('Set Identity', () {
      var m = Matrix4.create();
      expect(m.e[Matrix4.m00] == 1.0, isTrue);
      expect(m.e[Matrix4.m11] == 1.0, isTrue);
      expect(m.e[Matrix4.m22] == 1.0, isTrue);
      expect(m.e[Matrix4.m33] == 1.0, isTrue);

      expect(m.e[Matrix4.m01] == 0.0, isTrue);
      expect(m.e[Matrix4.m02] == 0.0, isTrue);
      expect(m.e[Matrix4.m03] == 0.0, isTrue);

      expect(m.e[Matrix4.m10] == 0.0, isTrue);
      expect(m.e[Matrix4.m12] == 0.0, isTrue);
      expect(m.e[Matrix4.m13] == 0.0, isTrue);

      expect(m.e[Matrix4.m20] == 0.0, isTrue);
      expect(m.e[Matrix4.m21] == 0.0, isTrue);
      expect(m.e[Matrix4.m23] == 0.0, isTrue);

      expect(m.e[Matrix4.m30] == 0.0, isTrue);
      expect(m.e[Matrix4.m31] == 0.0, isTrue);
      expect(m.e[Matrix4.m32] == 0.0, isTrue);
    });

    test('Set Translate', () {
      var m = Matrix4.create();
      m.setToTranslate(1.0, 2.0, 3.0);
      expect(m.e[Matrix4.m03] == 1.0, isTrue);
      expect(m.e[Matrix4.m13] == 2.0, isTrue);
      expect(m.e[Matrix4.m23] == 3.0, isTrue);
    });

    test('Set Rotation', () {
      var m = Matrix4.create();
      const rotAngle = 45.0 * degreesToRadians;

      m.setRotation(rotAngle);
      expect(m.e[Matrix4.m00] == cos(rotAngle), isTrue);
      expect(m.e[Matrix4.m01] == -sin(rotAngle), isTrue);
      expect(m.e[Matrix4.m10] == sin(rotAngle), isTrue);
      expect(m.e[Matrix4.m11] == cos(rotAngle), isTrue);
    });

    test('Rotate vector ccw', () {
      //            +y
      //             |
      //             |
      //             | vector points in this quadrant
      // -x ------------------- +x
      //             |
      //             |
      //             |
      //            -y

      var m = Matrix4.create();
      const rotAngle = 25.0 * degreesToRadians;
      m.setRotation(rotAngle);

      var v = Vector3.create3(1.0, 0.0, 0.0);
      var rotated = Vector3.create();

      m.transformVector(v, rotated);
      expect(rotated.x == cos(rotAngle), isTrue,
          reason: 'Expected: ${cos(rotAngle)}');
      expect(rotated.y == sin(rotAngle), isTrue,
          reason: 'Expected: ${sin(rotAngle)}');
      expect(rotated.z == 0.0, isTrue);
    });

    test('Rotate vector cw', () {
      //            +y
      //             |
      //             |
      //             |
      // -x ------------------- +x
      //             | vector points in this quadrant
      //             |
      //             |
      //            -y

      var m = Matrix4.create();
      const rotAngle = -25.0 * degreesToRadians;
      m.setRotation(rotAngle);

      var v = Vector3.create3(1.0, 0.0, 0.0);
      var transformed = Vector3.create();

      m.transformVector(v, transformed);
      if (kDebugMode) {
        print('Rotated $transformed');
      }

      expect(transformed.x == cos(rotAngle), isTrue,
          reason: 'Expected: ${cos(rotAngle)}');
      expect(transformed.y == sin(rotAngle), isTrue,
          reason: 'Expected: ${sin(rotAngle)}');
      expect(transformed.z == 0.0, isTrue);
    });

    test('Translate vector point', () {
      var m = Matrix4.create();
      m.setToTranslate(1.0, 1.0, 0.0);

      var v = Vector3.create3(1.0, 0.0, 0.0);
      var transformed = Vector3.create();

      m.transformVector(v, transformed);
      if (kDebugMode) {
        print('Translated $transformed');
      }

      expect(transformed.x == 2.0, isTrue, reason: 'Expected: 2.0');
      expect(transformed.y == 1.0, isTrue, reason: 'Expected: 1.0');
      expect(transformed.z == 0.0, isTrue, reason: 'Expected: 0.0');
    });

    test('Scale vector', () {
      var m = Matrix4.create();
      m.setScale2Comp(3.0, 1.0);

      var v = Vector3.create3(1.0, 2.0, 3.0);
      var transformed = Vector3.create();

      m.transformVector(v, transformed);
      if (kDebugMode) {
        print('Translated $transformed');
      }

      expect(transformed.x == 3.0, isTrue, reason: 'Expected: 3.0');
      expect(transformed.y == 2.0, isTrue, reason: 'Expected: 2.0');
      expect(transformed.z == 0.0, isTrue, reason: 'Expected: 0.0');
    });
  });
}
