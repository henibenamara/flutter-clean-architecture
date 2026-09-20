part of 'todo_bloc.dart';

enum TodoStatus { loading, success, failure }

/// What the screen renders. Immutable, so a change is a new state.
final class TodoState extends Equatable {
  const TodoState({
    this.status = TodoStatus.loading,
    this.todos = const [],
    this.errorMessage,
  });

  final TodoStatus status;
  final List<Todo> todos;
  final String? errorMessage;

  /// Note: [errorMessage] is not carried over. A copy without one clears it.
  TodoState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    String? errorMessage,
  }) {
    return TodoState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, todos, errorMessage];
}
