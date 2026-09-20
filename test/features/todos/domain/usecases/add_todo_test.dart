import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/repositories/todo_repository.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/add_todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository repository;
  late AddTodo addTodo;

  setUp(() {
    repository = MockTodoRepository();
    addTodo = AddTodo(repository);
  });

  test('trims the title and forwards it to the repository', () async {
    const saved = Todo(id: '1', title: 'Write tests');
    when(() => repository.addTodo('Write tests'))
        .thenAnswer((_) async => const Ok(saved));

    final result = await addTodo('  Write tests  ');

    expect(result, isA<Ok<Todo>>());
    verify(() => repository.addTodo('Write tests')).called(1);
  });

  test('rejects a blank title without touching the repository', () async {
    final result = await addTodo('   ');

    expect(result, isA<Err<Todo>>());
    expect((result as Err<Todo>).failure, isA<ValidationFailure>());
    verifyZeroInteractions(repository);
  });
}
