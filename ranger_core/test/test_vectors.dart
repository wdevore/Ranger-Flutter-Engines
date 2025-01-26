import 'dart:math';

import 'package:ranger_core/src/maths/constants.dart';
import 'package:ranger_core/src/maths/vector.dart';
import 'package:test/test.dart';

void testVectors() {
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
}
