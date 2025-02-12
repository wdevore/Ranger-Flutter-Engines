import '../event.dart';
import '../node_manager.dart';
import 'scene_manager.dart';

enum SceneType {
  none,
  incoming,
  outgoing,
}

/// Boot scenes and Splash scenes are typical examples.
abstract class Scene with Events {
  String name = 'unknown';

  SceneType type = SceneType.none;

  late NodeManager man;
  late SceneManager sceneMan;

  SceneState currentState = SceneState.sceneOffStage;
  SceneState previousState = SceneState.sceneOffStage;

  void initializeScene(SceneState current, SceneState previous) {
    currentState = current;
    previousState = previous;
  }

  void build();
  SceneState update(double interpolation);

  /// [notify] is a callback from NodeManager indicating a state change.
  void notify(SceneState state) {
    previousState = currentState;
    currentState = state;
  }
}
