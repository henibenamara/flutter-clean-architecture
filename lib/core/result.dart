import 'package:flutter_clean_architecture/core/error/failures.dart';

/// Outcome of an operation that can fail, without throwing across layers.
///
/// Use cases and repositories return a [Result]; the presentation layer
/// pattern-matches on it, so every failure path has to be handled.
sealed class Result<T> {
  const Result();
}

/// The operation succeeded and produced [value].
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// The operation failed with a domain-level [failure].
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
