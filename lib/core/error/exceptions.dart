/// Thrown by data sources when storage access fails.
///
/// Exceptions never leave the data layer: repositories catch them and return
/// a `Failure` instead.
class StorageException implements Exception {
  const StorageException(this.message);

  final String message;

  @override
  String toString() => 'StorageException: $message';
}
