import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';

/// Implements the domain contract on top of a [TodoLocalDataSource].
///
/// Its two jobs: map data models to entities, and turn data-layer exceptions
/// into domain [Failure]s so nothing throws past this boundary.
class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._dataSource);

  final TodoLocalDataSource _dataSource;

  @override
  Future<Result<List<Todo>>> getTodos() {
    return _guard(() async {
      final models = await _dataSource.fetchTodos();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Result<Todo>> addTodo(String title) {
    return _guard(() async => (await _dataSource.insert(title)).toEntity());
  }

  @override
  Future<Result<Todo>> toggleTodo(String id) {
    return _guard(() async => (await _dataSource.toggle(id)).toEntity());
  }

  @override
  Future<Result<void>> deleteTodo(String id) {
    return _guard<void>(() => _dataSource.remove(id));
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Ok(await action());
    } on StorageException catch (error) {
      return Err(StorageFailure(error.message));
    }
  }
}
