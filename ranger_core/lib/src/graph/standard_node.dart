import '../maths/matrix4.dart';
import 'node.dart';

final class StandardNode extends Node {
  StandardNode();

  factory StandardNode.create(String name) => StandardNode()..name = name;

  @override
  void initialize(String name) {
    // TODO stuff here
    super.initialize(name);
  }

  @override
  void render(Matrix4 model) {
    // TODO: implement draw
  }
}
