class NodeException implements Exception {
  final String message;
  NodeException(this.message);

  @override
  String toString() {
    return 'NodeException: $message';
  }
}

class WorldException implements Exception {
  final String message;
  WorldException(this.message);

  @override
  String toString() {
    return 'WorldException: $message';
  }
}
