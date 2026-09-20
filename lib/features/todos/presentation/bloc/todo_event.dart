part of 'todo_bloc.dart';

/// Everything the UI can ask the bloc to do.
sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

/// The screen opened: load the list.
final class TodosStarted extends TodoEvent {
  const TodosStarted();
}

final class TodoAdded extends TodoEvent {
  const TodoAdded(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

final class TodoToggled extends TodoEvent {
  const TodoToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class TodoDeleted extends TodoEvent {
  const TodoDeleted(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
