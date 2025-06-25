class NoConnectionException implements Exception {
  final String message;
  NoConnectionException([this.message = 'No internet connection']);

  @override
  String toString() => 'NoConnectionException: $message';
}
