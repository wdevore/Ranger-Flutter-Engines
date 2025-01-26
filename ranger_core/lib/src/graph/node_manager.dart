import '../exceptions.dart';
import '../maths/matrix4.dart';
import 'node.dart';
import 'node_stack.dart';
import 'scene.dart';
import 'transform_stack_cached.dart';

/// The node manager is basically the SceneGraph
class NodeManager {
  // Clear or render background. Some nodes take the entire render area
  // so clearing or render a background is wasteful.
  bool clearBackground = false;

  late NodeStack stack;
  late TransformStackCached transformStack;
  List<Node> timingTargets = [];
  List<Node> eventTargets = [];

  late Node root;
  Node? scenes;

  Node? nextScene;
  Node? currentScene;

  // projection *display.Projection
  // viewport   *display.Viewport

  final Matrix4 preM4 = Matrix4.identity();
  final Matrix4 postM4 = Matrix4.identity();

  NodeManager();

  factory NodeManager.create() {
    NodeManager nm = NodeManager();

    nm.stack = NodeStack.create();
    nm.transformStack = TransformStackCached.create();

    return nm;
  }

  void configure() {
    var identity = Matrix4.identity();
    transformStack.initialize(identity);
  }

  void begin() {
    if (stack.isEmpty || stack.stack.length < 2) {
      throw NodeException(
          'begin: Not enough scenes to start engine. There must be 2 or more');
    }

    // The currentScene is the Incoming scene.
    currentScene = stack.pop();
    if (currentScene == null) {
      throw NodeException('begin: No current scene.');
    }
    enterScene(currentScene!);

    // We need to set next-scene to the Top incase the game
    // starts with only two scenes.
    nextScene = stack.top();

    scenes = root.getChildByName('Scenes');
  }

  bool visit(double interpolation) {
    transformStack.save();

    // Up to two Scene Nodes can run at a time: Outgoing and Incoming.
    var visitState = continueVisit(interpolation);

    transformStack.restore();

    return visitState; // continue to draw.
  }

  bool continueVisit(double interpolation) {
    if (currentScene != null && currentScene is! Scene) {
      throw NodeException('continueVisit: Current Scene node is not a Scene.');
    }

    if (scenes == null) {
      throw NodeException('continueVisit: scene collection is null');
    }

    var currentState = (currentScene as Scene).currentState;

    switch (currentState) {
      case SceneStates.sceneOffStage:
        // The current scene is off stage which means we need to tell it
        // to begin transitioning onto the stage.
        scenes!.insertShift(currentScene!);

        setSceneState(
            currentScene as Scene, SceneStates.sceneTransitionStartIn);
        break;
      case SceneStates.sceneTransitionStartOut:
        // The current scene wants to transition off the stage.
        // Notify it that it can do so.
        setSceneState(
            currentScene as Scene, SceneStates.sceneTransitionStartOut);

        // At the same time we need to tell the next scene (if there is one) that it can
        // start transitioning onto the stage.
        if (stack.isEmpty) {
          // fmt.Println("---- Stack empty ------")
          nextScene = null;
        } else {
          if (nextScene != null && nextScene is! Scene) {
            throw NodeException(
                'continueVisit: Next Scene node is not a Scene.');
          }
          nextScene = stack.pop();

          enterScene(nextScene!);

          setSceneState(nextScene as Scene, SceneStates.sceneTransitionStartIn);
          scenes!.insertShift(nextScene!);
        }
        break;
      case SceneStates.sceneExitedStage:
        // The current scene has finished leaving the stage.
        // TODO replace "pooled" with "cleanup/dispose"
        var pooled = exitScene(currentScene!); // Let it cleanup and exit.

        if (pooled) {
          // Returning currentScene to pool.
        }

        scenes!.removeLast();

        // Promote next-scene to current-scene
        currentScene = nextScene;
        // This isn't actually needed but it is good form.
        nextScene = null;
        break;
      default:
        break;
    }

    // -------------------------------------------------------
    // Now that visible Scene(s) have been attached/detached to the main Scene
    // node we can Visit the "Root" node.
    // -------------------------------------------------------
    Node.visit(root, transformStack, interpolation);

    // When the current scene is the last scene to exit the stage
    // then the game is over.
    return currentScene != null;
  }

  /// [end] cleans up NodeManager by clearing the stack and calling all Exits
  void end() {
    // Dump the stack
    print("End: Cleaning up scene stack.");
    if (!stack.isEmpty) {
      var pn = stack.top();

      while (pn != null) {
        exitScene(pn);
        pn = stack.pop();
      }
    }

    eventTargets = [];
  }

  /// Push node onto the top
  void pushNode(Node node) {
    stack.push(node);
  }

  void setSceneState(Scene scene, SceneStates state) {
    scene.notify(state);
  }

// --------------------------------------------------------------------------
// Timing
// --------------------------------------------------------------------------
  void update(double msPerUpdate, double secPerUpdate) {
    for (var target in timingTargets) {
      target.update(msPerUpdate, secPerUpdate);
    }
  }

  void registerTarget(Node target) {
    timingTargets.add(target);
  }

  void unRegisterTarget(Node target) {
    timingTargets.remove(target);
  }

  // -----------------------------------------------------
  // Scene lifecycles
  // -----------------------------------------------------
  void enterScene(Node node) {
    node.enterScene(this);

    for (var child in node.children) {
      enterNode(child);
    }
  }

  void enterNode(Node node) {
    enterNode(node);

    for (var child in node.children) {
      enterNode(child);
    }
  }

  bool exitScene(Node node) {
    var pooled = false;

    pooled = node.exitScene(this);

    for (var child in node.children) {
      enterNode(child);
    }

    return pooled;
  }

  void exitNode(Node node) {
    node.exitNode(this);

    for (var child in node.children) {
      exitNode(child);
    }
  }
}
