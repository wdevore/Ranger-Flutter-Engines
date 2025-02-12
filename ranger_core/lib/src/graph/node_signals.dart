import 'node.dart';

mixin Signals {
  void receiveSignal(NodeSignal signal) {}
  void sendSignal(NodeSignal signal) {}
}
