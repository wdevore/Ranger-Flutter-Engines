import 'package:flutter/material.dart';
import 'package:ranger_core/ranger_core.dart';

import 'engine.dart';

class GameApp extends StatelessWidget {
  final Engine engine;

  const GameApp({super.key, required this.engine});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Dragging',
      debugShowCheckedModeBanner: false,
      home: _GamePage(engine),
    );
  }
}

class _GamePage extends StatefulWidget {
  final Engine engine;

  const _GamePage(this.engine);

  @override
  _GamePageState createState() {
    return _GamePageState();
  }
}

class _GamePageState extends State<_GamePage>
    with SingleTickerProviderStateMixin {
  // The controller and animation provide the 'ticks' that trigger the
  // custom painter to paint. The custom painter listens to the animation for
  // notifications and on each notification the painter paints.
  // The controller generates the ticks.
  late AnimationController _controller;
  late Animation<double> _animation;

  _GamePageState();

  @override
  Widget build(BuildContext context) {
    Engine engine = widget.engine;

    return Scaffold(
      body: Listener(
        // Scroll wheel events
        onPointerSignal: (event) => engine.inputPointerSignal(event),
        child: MouseRegion(
          onHover: (event) => engine.inputMouseMove(event),
          child: GestureDetector(
            // TapDown is cancelled if the mouse moves, but PanStart triggers
            // instead.
            // onTapDown: (details) => print('onTapDown: $details'),
            // onTapUp: (details) => print('onTapUp: $details'),
            // onTapCancel: () => print('onTapCancel'),
            // PanDown is suppressed if TapDown is present above.
            onPanDown: (details) => engine.inputPanDown(details),
            onPanStart: (details) => engine.inputPanStart(details),
            onPanEnd: (details) => engine.inputPanEnd(details),
            onPanUpdate: (details) => engine.inputPanUpdate(details),
            child: CustomPaint(
              painter: GamePainter(engine, _animation, _controller),
              child: _buildErrorExceptionOverlay(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorExceptionOverlay() {
    switch (widget.engine.state) {
      case EngineState.exited:
        return Center(child: Text('Engine Exited'));
      case EngineState.halted:
        return Center(child: Text('Engine halted'));
      default:
        return SizedBox.expand(); // Be as big as possible
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat();
  }
}
