import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';

/// Removes a todo.
class DeleteTodo {
  const DeleteTodo(this._repository);

  final TodoRepository _repository;

  Future<Result<void>> call(String id) => _repository.deleteTodo(id);
}
