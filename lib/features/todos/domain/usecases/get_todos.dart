import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';

/// Loads every todo.
class GetTodos {
  const GetTodos(this._repository);

  final TodoRepository _repository;

  Future<Result<List<Todo>>> call() => _repository.getTodos();
}
