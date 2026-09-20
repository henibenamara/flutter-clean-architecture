import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todos/data/models/todo_model.dart';

/// Keeps todos in memory. Good enough for a demo and for fast, deterministic
/// tests; data is lost when the app closes.
class InMemoryTodoLocalDataSource implements TodoLocalDataSource {
  InMemoryTodoLocalDataSource({List<TodoModel> initial = const []})
      : _todos = List<TodoModel>.of(initial),
        _nextId = initial.length + 1;

  final List<TodoModel> _todos;
  int _nextId;

  @override
  Future<List<TodoModel>> fetchTodos() async {
    return List<TodoModel>.unmodifiable(_todos);
  }

  @override
  Future<TodoModel> insert(String title) async {
    final todo = TodoModel(id: (_nextId++).toString(), title: title);
    _todos.add(todo);
    return todo;
  }

  @override
  Future<TodoModel> toggle(String id) async {
    final index = _indexOf(id);
    final updated = _todos[index].copyWith(isDone: !_todos[index].isDone);
    _todos[index] = updated;
    return updated;
  }

  @override
  Future<void> remove(String id) async {
    _todos.removeAt(_indexOf(id));
  }

  int _indexOf(String id) {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      throw StorageException('No todo with id $id');
    }
    return index;
  }
}
