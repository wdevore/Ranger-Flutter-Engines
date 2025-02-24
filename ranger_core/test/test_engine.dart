import 'package:ranger_core/ranger_core.dart' as core;
import 'package:test/test.dart';

import 'engine.dart';
import 'node_basic_splash.dart';

void testEngine() {
  group('Engine', () {
    test('Engine boot', () {
      Engine engine = Engine.create('relativePath', 'overrides');

      String message = '';
      try {
        engine.boot('');
      } on core.NodeException catch (e) {
        print(e);
        message = e.message;
      }
      // expect(() => engine.begin(), throwsA(isA<NodeException>),
      //     reason: 'Expected NodeException as a result of no ...');

      // expect(engine.lastException == null, isTrue);
      expect(
        message == '',
        isTrue,
      );
    });

    test('Basic Minimal setup', () {
      Engine engine = Engine.create('relativePath', 'overrides');

      // The NodeManager builds a baseline Node structure:
      //
      //                            Root
      //         /-----------------/  | \-----------------\
      //         |                    |                   |
      //      Underlay              Nodes             Overlay

      core.WorldCore world = engine.world;

      NodeBasicSplash splash = NodeBasicSplash.create('Splash', world);
      world.nodeManager.addNode(splash);

      // world.nodeManager.pushNode('Splash');
      // Tree.print(
      //     world.nodeManager.nodeStack, world.nodeManager.nodeStack.first);

      engine.runOneLoop = true; // We don't want the engine to continue running.

      // The run stack needs at least 1 Node
      engine.boot(splash.name);

      // We don't expect an exception because Nodes were pushed.
      expect(engine.lastException == null, isTrue);
    });
  });
}
