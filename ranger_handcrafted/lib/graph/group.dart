import 'dart:collection';

import 'node.dart';

mixin Group {
  late ListQueue<Node> children;

  initializeGroup() {
    children = ListQueue<Node>();
  }

  Node? getChildByID(int id) {
    if (children.isNotEmpty) {
      for (var child in children) {
        if (child.id == id) {
          return child;
        }
      }
    }

    return null;
  }

  Node? getChildByName(String name) {
    if (children.isNotEmpty) {
      for (var child in children) {
        if (child.name == name) {
          return child;
        }
      }
    }

    return null;
  }

  /// Prepend node and return last.
  Node? insertShift(Node node) {
    children.addFirst(node);

    return children.last;
  }

  Node removeLast() => children.removeLast();
}
