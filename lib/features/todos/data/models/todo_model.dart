import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';

/// Data-layer representation of a [Todo], with JSON (de)serialization.
///
/// Keeping it separate from the entity means storage details (field names,
/// formats) can change without touching the domain.
class TodoModel {
  const TodoModel({required this.id, required this.title, this.isDone = false});

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final bool isDone;

  TodoModel copyWith({bool? isDone}) {
    return TodoModel(id: id, title: title, isDone: isDone ?? this.isDone);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }

  Todo toEntity() => Todo(id: id, title: title, isDone: isDone);
}
