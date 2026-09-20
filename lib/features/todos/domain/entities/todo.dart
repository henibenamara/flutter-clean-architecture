import 'package:equatable/equatable.dart';

/// A task the user wants to get done. Pure Dart: no Flutter, no JSON.
class Todo extends Equatable {
  const Todo({required this.id, required this.title, this.isDone = false});

  final String id;
  final String title;
  final bool isDone;

  Todo copyWith({String? title, bool? isDone}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [id, title, isDone];
}
