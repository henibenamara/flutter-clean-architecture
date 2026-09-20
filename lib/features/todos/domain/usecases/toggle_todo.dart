import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';

/// Flips the done flag of a todo.
class ToggleTodo {
  const ToggleTodo(this._repository);

  final TodoRepository _repository;

  Future<Result<Todo>> call(String id) => _repository.toggleTodo(id);
}
