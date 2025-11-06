/// Represents a failure or error in the application.
class Failure implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// Optional error code for categorizing the failure.
  final String? code;

  /// Creates a Failure with the given message and optional code.
  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure($code): $message';
}
