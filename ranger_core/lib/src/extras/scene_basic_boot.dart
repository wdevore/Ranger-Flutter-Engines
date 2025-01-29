import '../graph/node.dart';
import '../graph/node_manager.dart';
import '../graph/scene.dart';

/// This boot scene does absolutely nothing other than
/// satisfying the NodeManager requirement for 2 scenes.
/// So just simply exit the stage immdediately.
class SceneBasicBoot extends Node {
  SceneBasicBoot();

  factory SceneBasicBoot.create(String name) {
    SceneBasicBoot scene = SceneBasicBoot()
      ..initialize(name)
      ..initializeScene(SceneStates.sceneOffStage, SceneStates.sceneOffStage);
    return scene;
  }

  // --------------------------------------------------------
  // Transitioning
  // --------------------------------------------------------

  @override
  void notify(SceneStates state) {
    print('SceneBasicBoot notify: $name :: $state');

    // switch (state) {
    //   case SceneStates.sceneTransitionStartIn:
    //     // TODO Add delay before transitioning
    //     currentState = SceneStates.sceneTransitioningIn;
    //     break;
    //   case SceneStates.sceneTransitionStartOut:
    //     currentState = SceneStates.sceneTransitioningOut;
    //     break;
    //   default:
    currentState = SceneStates.sceneExitedStage;
    //     break;
    // }
  }

  @override
  void enterScene(NodeManager man) {
    print('SceneBasicBoot Enter scene: $name');
    // man.registerTarget(this);
  }

  @override
  bool exitScene(NodeManager man) {
    print('SceneBasicBoot Exit scene: $name');
    // man.unRegisterTarget(this);
    return false;
  }
}
