// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ranger_handcrafted/maths/constants.dart';
import 'package:ranger_handcrafted/maths/matrix4.dart';
import 'package:ranger_handcrafted/maths/vector.dart';
import 'package:ranger_handcrafted/maths/vector3.dart';

void main() {
  group('Vector', () {
    test('Add', () {
      var am = Vector.create(2.0, 2.0);
      am.add(2.5, 1.5);
      expect(am.x == 4.5, isTrue);
      expect(am.y == 3.5, isTrue);
    });

    test('Sub', () {
      var am = Vector.create(2.0, 2.0);
      am.sub(2.5, 1.5);
      expect(am.x == -0.5, isTrue);
      expect(am.y == 0.5, isTrue);
    });

    test('Two vectors orthogonal', () {
      var xAxis = Vector.create(2.0, 0.0);
      var yAxis = Vector.create(0.0, 2.0);
      // Convert radians to degrees
      double angle = Vector.angle(xAxis, yAxis) / degreesToRadians;
      expect(angle == 90.0, isTrue);
    });

    test('Two vectors 45 degrees apart', () {
      const angleComp = 25.0;

      var xAxis = Vector.create(2.0, 0.0);
      var offAxis = Vector.create(
          cos(angleComp * degreesToRadians), sin(angleComp * degreesToRadians));
      // Convert radians to degrees
      double angle = Vector.angle(xAxis, offAxis) / degreesToRadians;
      expect((angle - angleComp).abs() <= epsilon, isTrue);
    });

    test('Two vectors 25 degrees apart', () {
      const angleComp = 25.0;
      var xAxis = Vector.create(2.0, 0.0);
      var offAxis = Vector.create(
          cos(angleComp * degreesToRadians), sin(angleComp * degreesToRadians));
      // Convert radians to degrees
      double angle = Vector.angle(xAxis, offAxis) / degreesToRadians;
      expect((angle - angleComp).abs() <= epsilon, isTrue);
    });

    test('Length', () {
      var am = Vector.create(2.0, 0.0);
      double len = am.length;
      expect(len == 2.0, isTrue);
    });
  });

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
