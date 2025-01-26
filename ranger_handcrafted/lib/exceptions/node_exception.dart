class NodeException implements Exception {
  final String message;
  NodeException(this.message);

  @override
  String toString() {
    return 'NodeException: $message';
  }
}
