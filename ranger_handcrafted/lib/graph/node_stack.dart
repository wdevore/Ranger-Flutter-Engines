import 'dart:collection';

import 'node.dart';

class NodeStack {
  late ListQueue<Node> stack;

  Node? nextNode;
  Node? runningNode;

  NodeStack();

  factory NodeStack.create() => NodeStack();

  bool get isEmpty => stack.isEmpty;

  void clearNextNode() => nextNode = null;

  void clearRunningNode() => runningNode = null;

  void push(Node node) {
    nextNode = node;
    stack.addFirst(node);
  }

  Node? pop() {
    if (stack.isEmpty) return null;

    nextNode = stack.removeFirst();
    return nextNode;
  }

  Node top() => stack.first;

  // Replacement is the act of popping and pushing. i.e. replacing
  // the stack top with the new node.
  void replaceTop(Node replacement) {
    if (stack.isNotEmpty) {
      stack.removeFirst();
    }
    stack.addFirst(replacement);
  }
}
