import 'package:ranger_core/src/exceptions.dart';
import 'package:ranger_core/src/extras/scene_basic_boot.dart';
import 'package:ranger_core/src/graph/node.dart';
import 'package:test/test.dart';

import 'engine.dart';
import 'scene_basic_splash.dart';
import 'world.dart';

void testEngine() {
  group('Engine', () {
    test('Begin exception', () {
      Engine engine = Engine.create('relativePath', 'overrides');

      String message = '';
      try {
        engine.begin();
      } on NodeException catch (e) {
        print(e);
        message = e.message;
      }
      // expect(() => engine.begin(), throwsA(isA<NodeException>),
      //     reason: 'Expected NodeException as a result of no Scenes');

      // expect(engine.lastException == null, isTrue);
      // We expect the exception because we didn't add any scenes.
      expect(
        message ==
            'begin: Not enough scenes to start engine. There must be 2 or more',
        isTrue,
        reason: 'Exception begin exception',
      );
    });

    test('Basic Minimal setup', () {
      Engine engine = Engine.create('relativePath', 'overrides');

      // The NodeManager builds a baseline Node structure:
      //
      //                            Root
      //         /-----------------/  | \-----------------\
      //         |                    |                   |
      //      Underlay              Scenes             Overlay
      //                              |
      //                              -- stack [Scenes]
      //                                    \
      //                              In:Boot Scene -> Out:Splash Scene
      //                                                     |
      //                                                   Layer

      World world = engine.world;

      SceneBasicSplash splash = SceneBasicSplash.create('Splash', world);
      world.push(splash);

      // Last scene pushed is the first to run.
      SceneBasicBoot boot = SceneBasicBoot.create(
        'Boot',
      );
      world.push(boot);

      Node.printTree(world.sceneStack, world.root);

      engine.runOneLoop = true; // We don't want the engine to continue running.

      engine.begin();

      // We don't expect an exception because Nodes were pushed.
      expect(engine.lastException == null, isTrue);
    });
  });
}
