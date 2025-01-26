import 'dart:collection';

import '../maths/affinetransform.dart';
import '../maths/matrix4.dart';

// const _transformStackDepth = 10;

// class TransformStackItem {
//   late Matrix4 current;

//   TransformStackItem();

//   factory TransformStackItem.create() =>
//       TransformStackItem()..current = Matrix4.identity();
// }

// Note: This takes less memory but requires a allocation per save. The
// cached version only requires a copy.
class TransformStack {
  late ListQueue<Matrix4> stack;
  int stackTop = 0;

  late Matrix4 current;
  late Matrix4 post; // Pre allocated cache

  late Matrix4 m4;

  TransformStack();

  factory TransformStack.create() {
    TransformStack t = TransformStack()
      ..current = Matrix4.identity()
      ..post = Matrix4.identity()
      ..m4 = Matrix4.identity();
    return t;
  }

  void initialize(Matrix4 mat) {
    // stack =
    //     List.generate(_transformStackDepth, (_) => TransformStackItem.create());

    // The initial value ready for the top of the stack.
    current.setFrom(mat);
  }

  Matrix4 apply(Matrix4 aft) {
    // Concat this transform onto the current transform but don't push it.
    // Use post multiply
    Matrix4.multiplyM4(current, aft, post); // Post-multiply
    current.setFrom(post);

    return current;
  }

  Matrix4 applyAffine(AffineTransform aft) {
    // Concat this transform onto the current transform but don't push it.
    // Use post multiply
    m4.setFromAffine(aft);
    Matrix4.multiplyM4(current, m4, post); // Post-multiply
    current.setFrom(post);

    return current;
  }

  void save() {
    // Push (a copy) of the current matrix onto the stack
    var top = Matrix4.createFrom(current);
    stack.addFirst(top);
    // var top = stack[stackTop];
    // top.current.setFrom(current);
    // stackTop++;
  }

  void restore() {
    // Pop top off stack
    current.setFrom(stack.removeFirst());
    // stackTop--;
    // var top = stack[stackTop];
    // current.setFrom(top.current);
  }
}
