import 'node.dart';
import 'node_manager.dart';

enum SceneStates {
  // SceneOffStage means a scene off the stage either destroyed,
  // on the stack or in a pool.
  sceneOffStage,

  // SceneTransitionStartIn : the scene is beginning to transition
  sceneTransitionStartIn,

  // SceneTransitioningIn : the scene is busy transitioning onto the stage
  sceneTransitioningIn,

  // SceneOnStage means a scene is actively doing on stage.
  sceneOnStage,

  // SceneTransitionStartOut : the scene is beginning to transition
  sceneTransitionStartOut,

  // SceneTransitioningOut : the scene is busy transitioning off the stage
  sceneTransitioningOut,

  // SceneExitedStage : the scene has finished transitioning off the stage
  sceneExitedStage,

  // SceneFinished means a scene is done. Destroy it and/or remove from pool.
  sceneFinished,
}

/// A [Scene] is just another [Node]
class Scene extends Node {
  SceneStates currentState = SceneStates.sceneOffStage;
  SceneStates previousState = SceneStates.sceneOffStage;

  double transitionDuration = 0.0;

  Scene();

  factory Scene.create(SceneStates current, SceneStates previous) => Scene()
    ..currentState = current
    ..previousState = previous;

// Notify is the channel NodeManager uses to cmd the Scene.
// This is the minimal required for an instant transition
// from Boot to first scene.
  void notify(SceneStates state) {
    switch (currentState) {
      case SceneStates.sceneTransitionStartIn:
        currentState = SceneStates.sceneTransitionStartOut;
        break;
      case SceneStates.sceneTransitionStartOut:
        currentState = SceneStates.sceneOnStage;
        break;
      default:
        currentState = state;
        break;
    }
  }

  /// [enterScene] called when it is time to transition a scene
  /// onto the stage.
  void enterScene(NodeManager man) {}

  bool exitScene(NodeManager man) {
    return true;
  }
}
