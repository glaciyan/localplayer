class ApiErrorException implements Exception {
  final String message;
  final String code;
  ApiErrorException([this.message = 'Unexpected Error', this.code = "unknown/error"]);

  @override
  String toString() => 'ApiErrorException: $code $message';
}
