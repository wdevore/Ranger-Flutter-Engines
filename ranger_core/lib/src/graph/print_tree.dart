import 'dart:collection';
import 'dart:io';

import 'node.dart';

const treeIndent = "   ";

class Tree {
  static void print(ListQueue<Node> nodeStack, Node node) {
    stdout.write('------------- Tree -------------------\n');
    _printBranch(0, node);

    if (node.children.isNotEmpty) {
      _printSubTree(nodeStack, node.children, 1);
    }

    stdout.write('------------- Stack -------------------\n');
    for (var node in nodeStack) {
      stdout.write('$node\n');
    }
  }

  static void _printSubTree(
      ListQueue<Node> nodeStack, ListQueue<Node> children, int level) {
    for (var child in children) {
      var subChildren = child.children;
      _printBranch(level, child);
      if (subChildren.isNotEmpty) {
        _printSubTree(nodeStack, subChildren, level);
      }
    }
  }

  static void _printBranch(int level, Node node) {
    // If a node's name begins with "::" then don't print it.
    // This is handy for particle systems or parent nodes with
    // lots of cloned children.
    if (node.name.substring(0, 2) == "::") {
      return;
    }

    for (var i = 0; i < level; i++) {
      stdout.write(treeIndent);
    }

    stdout.write('${node.name}\n');
  }
}
