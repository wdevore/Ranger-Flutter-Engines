import 'node_manager.dart';

mixin Lifecycle {
  // -----------------------------------------------------
// Scene lifecycles
// -----------------------------------------------------

// EnterNode is called when a node is being activiated. The node
// should track it own state to know if Enter has been called prior.
  void enterNode(NodeManager man) {
    // fmt.Println("Node: node enter")
  }

// EnterStageNode is called when a node may begin entering the stage.
  void enterStageNode(NodeManager man) {}

// ExitNode is called when a node is exiting stage
  void exitNode(NodeManager man) {}
}
