import '../graph/node.dart';
import '../graph/scene.dart';
import '../world.dart';

/// This boot scene does absolutely nothing other than
/// satisfying the NodeManager requirement for 2 scenes.
/// So just simply exit the stage immdediately.
class SceneBasicBoot extends Node {
  SceneBasicBoot();

  factory SceneBasicBoot.create(String name, World world) {
    SceneBasicBoot scene = SceneBasicBoot()
      ..world = world
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
