import 'package:flutter_clean_architecture/features/todos/data/datasources/in_memory_todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todos/data/models/todo_model.dart';
import 'package:flutter_clean_architecture/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/add_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/delete_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/get_todos.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/toggle_todo.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:get_it/get_it.dart';

/// The app's service locator.
final GetIt sl = GetIt.instance;

/// Wires the layers together: the only place that knows every concrete class.
/// Safe to call more than once.
void configureDependencies() {
  if (sl.isRegistered<TodoBloc>()) return;

  sl
    ..registerLazySingleton<TodoLocalDataSource>(
      () => InMemoryTodoLocalDataSource(
        initial: const [
          TodoModel(id: '1', title: 'Read the README'),
          TodoModel(id: '2', title: 'Explore the three layers', isDone: true),
          TodoModel(id: '3', title: 'Run the tests'),
        ],
      ),
    )
    ..registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetTodos(sl()))
    ..registerLazySingleton(() => AddTodo(sl()))
    ..registerLazySingleton(() => ToggleTodo(sl()))
    ..registerLazySingleton(() => DeleteTodo(sl()))
    ..registerFactory(
      () => TodoBloc(
        getTodos: sl(),
        addTodo: sl(),
        toggleTodo: sl(),
        deleteTodo: sl(),
      ),
    );
}
