import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/data/datasources/todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todos/data/models/todo_model.dart';
import 'package:flutter_clean_architecture/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late MockTodoLocalDataSource dataSource;
  late TodoRepositoryImpl repository;

  setUp(() {
    dataSource = MockTodoLocalDataSource();
    repository = TodoRepositoryImpl(dataSource);
  });

  test('maps data models to domain entities', () async {
    when(() => dataSource.fetchTodos()).thenAnswer(
      (_) async => const [TodoModel(id: '1', title: 'Buy milk', isDone: true)],
    );

    final result = await repository.getTodos();

    expect(result, isA<Ok<List<Todo>>>());
    expect(
      (result as Ok<List<Todo>>).value,
      const [Todo(id: '1', title: 'Buy milk', isDone: true)],
    );
  });

  test('turns a StorageException into a StorageFailure', () async {
    when(() => dataSource.toggle('9'))
        .thenThrow(const StorageException('boom'));

    final result = await repository.toggleTodo('9');

    expect(result, isA<Err<Todo>>());
    expect((result as Err<Todo>).failure, const StorageFailure('boom'));
  });

  test('deleting reports success when the data source succeeds', () async {
    when(() => dataSource.remove('1')).thenAnswer((_) async {});

    final result = await repository.deleteTodo('1');

    expect(result, isA<Ok<void>>());
    verify(() => dataSource.remove('1')).called(1);
  });
}
