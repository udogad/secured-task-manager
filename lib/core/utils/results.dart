import 'package:secure_task_manager/core/errors/failure.dart' show Failure;

/// Represents the result of an operation that can either succeed with a value or fail with an error.
sealed class Result<T> {
  const Result();

  /// Executes the appropriate function based on the [Result] type.
  ///
  /// If the result is [Ok], the [ok] function is called with the [value].
  /// If the result is [Err], the [err] function is called with the [failure].
  R when<R>({required R Function(T) ok, required R Function(Failure) err});
}

/// Represents a successful result containing a value.
class Ok<T> extends Result<T> {
  /// The successful value.
  final T value;

  /// Creates an Ok result with the given value.
  const Ok(this.value);

  @override
  R when<R>({required R Function(T) ok, required R Function(Failure) err}) =>
      ok(value);
}

/// Represents a failed result containing an error.
class Err<T> extends Result<T> {
  /// The failure that occurred.
  final Failure failure;

  /// Creates an Err result with the given failure.
  const Err(this.failure);

  @override
  R when<R>({required R Function(T) ok, required R Function(Failure) err}) =>
      err(failure);
}
