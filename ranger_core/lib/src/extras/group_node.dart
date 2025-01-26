import '../graph/node.dart';

/// [GroupNode] is a non-rendering node meant to contain children only.
class GroupNode extends Node {
  GroupNode();

  factory GroupNode.create(String name, Node? parent) {
    GroupNode g = GroupNode()
      ..initialize(name)
      ..parent = parent;

    parent?.children.add(g);

    return g;
  }
}
