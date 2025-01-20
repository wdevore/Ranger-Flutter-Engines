import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../geometry/rectangle.dart';
import '../maths/affinetransform.dart';
import '../maths/matrix4.dart';
import '../world.dart';
import 'filters/filter.dart';
import 'group.dart';
import 'event.dart';
import 'lifecycle.dart';
import 'transform.dart';
import 'transform_stack.dart';

const indent = "   ";

abstract class Node with Transform, Group, Lifecycle, Event {
  // Internal incrementing node id counter
  static int _iDcnt = 0;

  int id = 0;
  String name = '';

  // Associated pixel visual
  // AtlasX atlas;

  bool visible = true;

  bool dirty = true;

  Node? parent;
  late World world;

  late Rectangle bounds;

  void initialize(String name) {
    this.name = name;
    id = _iDcnt++;
    bounds = Rectangle.zero();
    initializeTransform();
    initializeGroup();
  }

  /// [visit] traverses **down** the heirarchy while space-mappings traverses
  /// **upward**.
  static void visit(Node node, TransformStack stack, double interpolation) {
    // Checking visibility here would cause any children that are visible
    // to not be rendered.
    // TODO Add parent and children flags for individual control.
    if (!node.visible) {
      // fmt.Printf("Node.Visit %v: Visible: %v\n", node, node.IsVisible())
      return;
    }

    stack.save();

    // TODO Because position and angles are dependent on lerping we perform
    // interpolation first.
    // node.interpolate(interpolation);

    var aft = node.calcTransform();

    var model = stack.applyAffine(aft);

    // TODO add Atlas features for images
    node.draw(model);

    // Some of the children may still be visible.
    // Note: if you want the parent AND children to be invisible then you
    // need to bubble visibility to parent and children.

    if (node.children.isNotEmpty) {
      for (var node in node.children) {
        if (node is Filter) {
          // TODO add filter.visit(stack, interpolation)
        } else {
          visit(node, stack, interpolation);
        }
      }
    }

    stack.restore();
  }

// CalcTransform calculates a matrix based on the
// current transform properties
  AffineTransform calcTransform() {
    if (dirty) {
      aft.makeTranslate(position.x, position.y);

      if (rotation != 0.0) {
        aft.rotate(rotation);
      }

      if (scale.x != 1.0 || scale.y != 1.0) {
        aft.scale(scale.x, scale.y);
      }

      // Invert...
      aft.invertTo(inverse);
    }

    return aft;
  }

  /// [draw] provides a default render--which is to draw nothing.
  ///
  /// You must **override** this in your custom [Node] if your [Node]
  /// needs to perform custom rendering.
  void draw(Matrix4 model) {}

  void setPosition(double x, double y) {
    position.x = x;
    position.y = y;
    rippleDirty(true);
  }

  void setRotation(double radians) {
    rotation = radians;
    rippleDirty(true);
  }

  void setScale(double scale) {
    this.scale.x = scale;
    this.scale.y = scale;
    rippleDirty(true);
  }

  void rippleDirty(bool dirty) {
    for (var child in children) {
      child.rippleDirty(dirty);
    }

    this.dirty = dirty;
  }

// SetBoundBySize set bounds centered at node's position.
  void setBoundBySize(double w, double h) {
    var hw = w / 2.0;
    var hh = h / 2.0;
    bounds.setByMinMax(
      position.x - hw,
      position.y - hh,
      position.x + hw,
      position.y + hh,
    );
  }

  bool hasParent() => parent != null;

// Update updates the time properties of a node.
  void update(double msPerUpdate, double secPerUpdate) {}

  // -----------------------------------------------------
  // Events
  // -----------------------------------------------------

  // Handle may handle an IO event
  bool handleEvent(Event event) {
    return false;
  }

  // -------------------------------------------------------------------
  // Misc
  // -------------------------------------------------------------------
  void printTree(Node node) {
    debugPrint('------------- Tree -------------------');
    printBranch(0, node);

    if (node.children.isNotEmpty) {
      printSubTree(children, 1);
    }
  }

  void printSubTree(ListQueue<Node> children, int level) {
    for (var child in children) {
      var subChildren = child.children;
      printBranch(level, child);
      if (subChildren.isNotEmpty) {
        printSubTree(subChildren, level);
      }
    }
  }

  void printBranch(int level, Node node) {
    // If a node's name begins with "::" then don't print it.
    // This is handy for particle systems or parent nodes with
    // lots of cloned children.
    if (node.name.substring(0, 2) == "::") {
      return;
    }

    for (var i = 0; i < level; i++) {
      debugPrint(indent);
    }

    debugPrint(node.name);
  }

  @override
  String toString() {
    return '<|\'$name\' ($id)|>';
  }
}
