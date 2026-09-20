import 'package:equatable/equatable.dart';

/// Domain-level errors. These are what the upper layers see; low-level
/// exceptions from the data layer are mapped to a [Failure] in repositories.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// The input did not satisfy a business rule.
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Reading from or writing to the data source failed.
final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}
