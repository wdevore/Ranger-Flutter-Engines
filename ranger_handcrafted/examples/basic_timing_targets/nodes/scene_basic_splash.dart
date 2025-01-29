import 'package:ranger_core/ranger_core.dart' as core;

import 'layer_basic_game.dart';
import '../world.dart';

class SceneBasicSplash extends core.Node {
  SceneBasicSplash();

  factory SceneBasicSplash.create(String name, World world) {
    SceneBasicSplash scene = SceneBasicSplash()
      ..initialize(name)
      ..build(world)
      ..initializeScene(
          core.SceneStates.sceneOffStage, core.SceneStates.sceneOffStage);
    return scene;
  }

  void build(World world) {
    LayerBasicGame.create('Game Layer', world, this);
  }

  // --------------------------------------------------------
  // Transitioning
  // --------------------------------------------------------
  @override
  void notify(core.SceneStates state) {
    print('SceneBasicSplash notify: $name :: $state');

    // currentState = core.SceneStates.sceneExitedStage;
  }

  @override
  void enterScene(core.NodeManager man) {
    print('SceneBasicSplash Enter scene: $name');
    man.registerTarget(this);
  }

  @override
  bool exitScene(core.NodeManager man) {
    print('SceneBasicSplash Exit scene: $name');
    man.unRegisterTarget(this);
    return false;
  }
}
