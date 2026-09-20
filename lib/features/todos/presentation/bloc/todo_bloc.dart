import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/add_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/delete_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/get_todos.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/toggle_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

/// Turns UI events into use-case calls and use-case results into states.
/// It only knows the domain layer, never the data layer.
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({
    required GetTodos getTodos,
    required AddTodo addTodo,
    required ToggleTodo toggleTodo,
    required DeleteTodo deleteTodo,
  })  : _getTodos = getTodos,
        _addTodo = addTodo,
        _toggleTodo = toggleTodo,
        _deleteTodo = deleteTodo,
        super(const TodoState()) {
    on<TodosStarted>(_onStarted);
    on<TodoAdded>((event, emit) => _mutate(() => _addTodo(event.title), emit));
    on<TodoToggled>((event, emit) => _mutate(() => _toggleTodo(event.id), emit));
    on<TodoDeleted>((event, emit) => _mutate(() => _deleteTodo(event.id), emit));
  }

  final GetTodos _getTodos;
  final AddTodo _addTodo;
  final ToggleTodo _toggleTodo;
  final DeleteTodo _deleteTodo;

  Future<void> _onStarted(TodosStarted event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    await _load(emit);
  }

  /// Runs a write use case, then reloads the list so the screen always shows
  /// what the data source actually holds.
  Future<void> _mutate<T>(
    Future<Result<T>> Function() action,
    Emitter<TodoState> emit,
  ) async {
    // Forget the previous error so the same error can be shown again.
    emit(state.copyWith());
    final result = await action();
    switch (result) {
      case Ok<T>():
        await _load(emit);
      case Err<T>(:final failure):
        emit(state.copyWith(errorMessage: failure.message));
    }
  }

  Future<void> _load(Emitter<TodoState> emit) async {
    final result = await _getTodos();
    switch (result) {
      case Ok(:final value):
        emit(TodoState(status: TodoStatus.success, todos: value));
      case Err(:final failure):
        emit(
          state.copyWith(
            status: TodoStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
