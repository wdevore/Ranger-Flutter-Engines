import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Keyboard events
  final FocusNode _focusNode = FocusNode(
    descendantsAreFocusable: false,
    onKeyEvent: (node, event) {
      switch (event.logicalKey.keyLabel) {
        case '`':
          SystemNavigator.pop();
          break;
        case 'K':
          if (event is KeyDownEvent) {
            // engine.inputKeyEvent(event);
            // print('K key');
            // var result = Process.run(
            //   runInShell: true,
            //   'xset',
            //   ['r', '30', '30'],
            // );
            // // result.whenComplete(() => print('K $result'));
            // result.whenComplete(() {
            //   if (result is ProcessResult) {
            //     result.then((onValue) => print(onValue));
            //   }
            //   print('K $result');
            // });
          }
          break;
        case 'O':
          // KeyRepeatEvent
          // if (event is KeyDownEvent) {
          //   print('O key');
          //   var result = Process.run(
          //     runInShell: true,
          //     'xset',
          //     ['r', '500', '33'],
          //   );
          //   result.whenComplete(() {
          //     print('O $result');
          //   });
          // }
          break;

        default:
          print('focusnode: $event');
          return KeyEventResult.ignored;
      }

      return KeyEventResult.handled;
    },
  );

  @override
  Widget build(BuildContext context) {
    Engine engine = widget.engine;
    // autofocus: true,
    // focusNode: _focusNode,

    return Scaffold(
      body: Listener(
        // Scroll wheel events
        onPointerSignal: (event) => engine.inputPointerSignal(event),
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
          // Focus must encapsilate MouseRegion otherwise you don't get events.
          child: Focus(
            autofocus: true,
            focusNode: KeyFocusNode(engine)
              ..onKeyEvent = (node, event) {
                switch (event.logicalKey.keyLabel) {
                  case '`':
                    SystemNavigator.pop();
                    break;
                  // case 'K':
                  //   engine.inputKeyEvent(event);
                  //   break;
                  // case 'O':
                  //   break;

                  default:
                    // print('focusnode: $event');
                    engine.inputKeyEvent(event);
                  // return KeyEventResult.ignored;
                }

                return KeyEventResult.handled;
              },
            child: MouseRegion(
              onHover: (event) => engine.inputMouseMove(event),
              child: CustomPaint(
                painter: GamePainter(engine, _animation, _controller),
                child: _buildErrorExceptionOverlay(),
              ),
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
    _focusNode.dispose();
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

class KeyFocusNode extends FocusNode {
  final EngineCore engine;
  KeyFocusNode(this.engine) {
    descendantsAreFocusable = false;
  }
}
