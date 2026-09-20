import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';

/// Contract the domain layer depends on. The data layer implements it, so
/// the domain never knows where todos are stored.
abstract interface class TodoRepository {
  Future<Result<List<Todo>>> getTodos();

  Future<Result<Todo>> addTodo(String title);

  Future<Result<Todo>> toggleTodo(String id);

  Future<Result<void>> deleteTodo(String id);
}
