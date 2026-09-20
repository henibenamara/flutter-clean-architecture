import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';

/// Adds a todo. The business rule "a title cannot be blank" lives here, so it
/// applies no matter which UI or data source is plugged in.
class AddTodo {
  const AddTodo(this._repository);

  final TodoRepository _repository;

  Future<Result<Todo>> call(String title) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return const Err(ValidationFailure('Title cannot be empty.'));
    }
    return _repository.addTodo(trimmed);
  }
}
