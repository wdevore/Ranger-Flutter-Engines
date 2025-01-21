import 'package:flutter_test/flutter_test.dart';
import 'package:ranger_handcrafted/engine.dart';
import 'package:ranger_handcrafted/extras/scene_basic_boot.dart';
import 'package:ranger_handcrafted/graph/node.dart';
import 'package:ranger_handcrafted/world.dart';

import 'scene_basic_splash.dart';

void testEngine() {
  group('Engine', () {
    test('Begin exception', () {
      Engine engine = Engine.create('relativePath', 'overrides');
      engine.begin(true);
      expect(engine.lastException != null, isTrue);
      // We expect the exception because we didn't add any scenes.
      expect(
        engine.lastException ==
            'begin: Not enough scenes to start engine. There must be 2 or more',
        isTrue,
        reason: 'Expection begin exception',
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
      //                           /      \
      //              In:Boot Scene        Out:Splash Scene
      //                                        |
      //                                      Layer

      World world = engine.world;

      SceneBasicSplash splash = SceneBasicSplash.create('Splash', world);
      world.push(splash);

      // Last scene pushed is the first to run.
      SceneBasicBoot boot = SceneBasicBoot.create('Boot', world);
      world.push(boot);

      Node.printTree(world.root); // TODO add printing of scenes too

      engine.begin(true);

      // We don't expect an exception because Nodes were pushed.
      expect(engine.lastException == null, isTrue);
    });
  });
}
