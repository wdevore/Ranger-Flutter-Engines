import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ranger_core/ranger_core.dart' as core;

import 'nodes/node_basic_splash.dart';
import 'world.dart';

class Engine extends core.EngineCore {
  final core.MouseEvent mouseEvent = core.MouseEvent();
  late core.DynamicTextNode fpsText;
  double _fpsCnt = 0.0;
  double _fpsSum = 0.0;
  final double _fpsMax = 10.0;

  Engine();

  factory Engine.create(String relativePath, String overrides) {
    Engine e = Engine()
      ..world = World.create(relativePath)
      ..state = core.EngineState.constructing;

    try {
      e
        ..configure()
        ..world.construct();
    } on core.WorldException catch (exp) {
      e.lastException = exp.message;
      stdout.write('${e.lastException}\n');
    }

    return e;
  }

  void configure() {
    world.nodeManager.configure();
  }

  /// [boot] is called after create() and as the last thing the engine
  /// does to start the game.
  @override
  void boot(String nodeName) {
    world.nodeManager.pushNode(nodeName);
  }

  void end() {
    world.end();
  }

  /// Called by GamePainter.
  @override
  void inputMouseMove(PointerHoverEvent event) {
    mouseEvent
      ..position = event.position
      ..delta = event.delta;
    world.nodeManager.event(mouseEvent);

    // print('mousemove: ${event.position} : ${event.delta}');
  }

  /// Called by GamePainter.
  @override
  void inputPanDown(DragDownDetails details) {
    print('pandown: $details');
  }

  /// Called by GamePainter.
  @override
  void inputPanUpdate(DragUpdateDetails details) {
    print('pandrag: $details');
  }

  /// Called by GamePainter.
  @override
  void update(double dt) {
    world.nodeManager.update(dt, 0.0);

    if (_fpsCnt > 9) {
      fpsText.setText(
          'fps ${(1.0 / (_fpsSum / _fpsCnt) * 1000.0).toStringAsFixed(2)}',
          world.atlas,
          0.5);
      _fpsCnt = 0.0;
      _fpsSum = 0.0;
    } else {
      _fpsCnt += 1.0;
      _fpsSum += dt;
    }
  }

  @override
  void render(Canvas canvas, Size size) {
    try {
      world.nodeManager.visit(0.0, canvas, size);
    } on core.NodeException catch (e) {
      state = core.EngineState.halted;
      debugPrint('$e');
    }
  }

  @override
  void construct() {
    NodeBasicSplash splash = NodeBasicSplash.create('Splash', world);
    // Preset Splash to replace NodeBasicBoot when boot exits.
    // Thus we add and push splash.
    var nm = world.nodeManager;

    nm.addPushNode(splash);

    core.NodeBasicBoot basicBoot = core.NodeBasicBoot.create('Boot', nm);
    nm.addNode(basicBoot);

    // Add FPS to overlay
    double scale = 15.0;
    // nm.overlay =
    //     core.StaticTextNode.create('-0.125', world, null, charSpacing: 0.5);
    // nm.overlay!.setPosition(scale, world.deviceSize.height - scale - 5);
    // nm.overlay!.setScale(scale);
    fpsText = core.DynamicTextNode.create('fps', world, null, charSpacing: 0.5);
    fpsText.setPosition(scale, world.deviceSize.height - scale - 5);
    fpsText.setScale(scale);
    nm.overlay = fpsText;

    // The run stack needs at least 1 Node
    boot(basicBoot.name);
  }
}
