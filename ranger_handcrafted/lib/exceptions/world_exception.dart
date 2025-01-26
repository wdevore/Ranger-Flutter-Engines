class WorldException implements Exception {
  final String message;
  WorldException(this.message);

  @override
  String toString() {
    return 'WorldException: $message';
  }
}
