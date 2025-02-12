import 'package:flutter/material.dart';

import '../../exceptions.dart';
import '../node_manager.dart';
import 'scene.dart';

// TODO DEPRECATED!!!!
//
// Scenes use the sceneMan to message each other.
// SM has atmost two active scenes.

enum SceneState {
  /// SceneOffStage means a scene off the stage either destroyed,
  /// on the stack or in a pool.
  sceneOffStage,

  /// SceneTransitionStartIn : the scene is beginning to transition
  sceneTransitionStartIn,

  /// SceneTransitioningIn : the scene is busy transitioning onto the stage
  sceneTransitioningIn,

  /// SceneOnStage means a scene is actively on stage.
  sceneOnStage,

  /// SceneTransitionStartOut : the scene is beginning to transition out
  sceneTransitionStartOut,

  /// SceneTransitioningOut : the scene is busy transitioning off the stage
  sceneTransitioningOut,

  /// SceneExitedStage : the scene has finished transitioning off the stage
  sceneExitedStage,

  /// SceneFinished means a scene is done. Destroy it and/or remove from List pool.
  sceneFinished,
}

// The [SceneManager](SM) controls how Scenes enter and exit the Stage.
// Scenes are either on a Stack or in a pool List.
// SM is a state machine. It waits for signals from Scenes to change state.

// The Stack is for Scenes entering and exiting. The List is a collection of
// Scenes that may eventually enter or exit the Stage.
// When a Scene begins entering the Stage the NodeManager is notified via
// enterStage signal.
// Some Scenes enter the Stage and never exit.
// If a Scene is pushed onto the Stack then it will "pushed" onto the Stage
// Either a Scene could get an Event to exit or the NodeManager could signal
// an exit.
// Scenes get signals from Nodes to change Scene state.
// Note: we only pop an out going Scene the incoming signals it wants to
// exit the Stage.
class SceneManager {
  Map<String, Scene> scenes = {};

  // There can only be atmost two Scenes visible in the Stage area.
  // One is coming In and the other is going Out.
  late Scene activeScene; // Also is the incoming Scene
  Scene? outScene;

  NodeManager nodeManager = NodeManager.create();

  SceneManager();

  factory SceneManager.create() => SceneManager();

  void start() {
    // Check that the Stack has atleast one Scene.
    if (scenes.isEmpty) {
      throw NodeException(
          'begin: Not enough scenes to start engine. There must be 1 or more');
    }
  }

  /// Called by Engine via GamePainter.paint(). False is returned if there are
  /// no more scenes to run. True if there a scene still in play
  bool update(double interpolation) {
    // The NodeManager will continue to run as long as there is an active Scene.

    // The active scene will return a signal.
    SceneState inState = activeScene.update(interpolation);

    switch (inState) {
      // The active Scene has just finished leaving the Stage.
      // It may have done so immediately without transitioning. If that
      // is so then the next scene should immediately appear without
      // transitioning.
      case SceneState.sceneExitedStage:
        // Tell other scenes that the active scene is no longer on the Stage.
        break;
      // Check to see if the incoming Scene wants to transition off the Stage.
      case SceneState.sceneTransitionStartOut:
        // inScene wants leave the Stage.
        // nodeManager.updateState(inScene, SceneState.sceneTransitionStartIn);

        // // Check if there is another Scene that can enter the stage.
        // if (scenes.isNotEmpty) {
        //   // The incoming scene is starting to leave which means it becomes
        //   // the outgoing scene.
        //   outScene = activeScene;
        //   nodeManager.updateState(outScene, SceneState.sceneTransitionStartOut);
        //   outScene!.type = SceneType.outgoing;
        //   //
        //   activeScene = scenes.removeFirst();
        //   nodeManager.updateState(
        //       activeScene, SceneState.sceneTransitionStartIn);
        //   activeScene!.type = SceneType.incoming;
        // } else {
        //   // Stack is empty. Once the inScene leaves then the game ends.
        // }
        break;
      default:
        break;
    }

    SceneState? outState = outScene?.update(interpolation);
    switch (outState) {
      default:
        break;
    }

    return true;
  }

  void visit(double interpolation, Canvas canvas) {
    nodeManager.visit(interpolation, canvas);
  }

  void setSceneState(Scene scene, SceneState state) {
    scene.notify(state);
  }

  // --------------------------------------------------------------------------
  // State management
  // --------------------------------------------------------------------------
  void updateState(SceneState state, Scene scene) {
    // A Scene has signaled a change of state.
    switch (state) {
      case SceneState.sceneTransitionStartIn:
        break;
      case SceneState.sceneTransitionStartOut:
        break;
      case SceneState.sceneFinished:
        // A Scene is signaling that we should toss it.
        // Remove it from the Stack.
        // scenes.removeWhere((scn) => scn.name == scene.name);
        // activeScene = null;
        break;
      default:
        break;
    }
  }

  void end() {
    // eventTargets.clear();
  }

  // -----------------------------------------------------
  // Scene sequences
  // -----------------------------------------------------
  // void enterScene(Node node) {
  //   if (node is Scene) {
  //     (node as Scene).enterScene(this);
  //   }

  //   for (var child in node.children) {
  //     enterNode(child);
  //   }
  // }

  // void enterNode(Node node) {
  //   node.enterNode(this);

  //   for (var child in node.children) {
  //     enterNode(child);
  //   }
  // }

  // bool exitScene(Node node) {
  //   var pooled = false;

  //   // pooled = node.exitScene(this);

  //   for (var child in node.children) {
  //     exitNode(child);
  //   }

  //   return pooled;
  // }

  // void exitNode(Node node) {
  //   node.exitNode(this);

  //   for (var child in node.children) {
  //     exitNode(child);
  //   }
  // }
}
