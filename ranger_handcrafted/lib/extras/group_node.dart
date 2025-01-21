import '../graph/node.dart';
import '../world.dart';

/// [GroupNode] is a non-rendering node meant to contain children only.
class GroupNode extends Node {
  GroupNode();

  factory GroupNode.create(String name, World world, Node? parent) {
    GroupNode g = GroupNode()
      ..initialize(name)
      ..parent = parent;

    parent?.children.add(g);

    return g;
  }
}
