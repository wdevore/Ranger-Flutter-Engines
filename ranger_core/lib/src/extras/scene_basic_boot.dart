import '../graph/node.dart';
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
    currentState = SceneStates.sceneExitedStage;
  }
}
