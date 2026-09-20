import 'package:flutter_clean_architecture/features/todos/data/models/todo_model.dart';

/// Where todos are read from and written to.
///
/// Implementations throw a StorageException when something goes wrong. Swap
/// the in-memory implementation for SQLite, Hive or a REST client without
/// changing any other layer.
abstract interface class TodoLocalDataSource {
  Future<List<TodoModel>> fetchTodos();

  Future<TodoModel> insert(String title);

  Future<TodoModel> toggle(String id);

  Future<void> remove(String id);
}
