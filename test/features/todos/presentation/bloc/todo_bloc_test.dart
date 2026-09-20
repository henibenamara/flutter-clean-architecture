import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/result.dart';
import 'package:flutter_clean_architecture/features/todos/domain/entities/todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/add_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/delete_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/get_todos.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/toggle_todo.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTodos extends Mock implements GetTodos {}

class MockAddTodo extends Mock implements AddTodo {}

class MockToggleTodo extends Mock implements ToggleTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

void main() {
  const milk = Todo(id: '1', title: 'Buy milk');
  const doneMilk = Todo(id: '1', title: 'Buy milk', isDone: true);

  late MockGetTodos getTodos;
  late MockAddTodo addTodo;
  late MockToggleTodo toggleTodo;
  late MockDeleteTodo deleteTodo;

  setUp(() {
    getTodos = MockGetTodos();
    addTodo = MockAddTodo();
    toggleTodo = MockToggleTodo();
    deleteTodo = MockDeleteTodo();
  });

  TodoBloc buildBloc() {
    return TodoBloc(
      getTodos: getTodos,
      addTodo: addTodo,
      toggleTodo: toggleTodo,
      deleteTodo: deleteTodo,
    );
  }

  group('TodosStarted', () {
    blocTest<TodoBloc, TodoState>(
      'emits loading, then the loaded todos',
      setUp: () {
        when(() => getTodos()).thenAnswer((_) async => const Ok([milk]));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const TodosStarted()),
      expect: () => const [
        TodoState(status: TodoStatus.loading),
        TodoState(status: TodoStatus.success, todos: [milk]),
      ],
    );

    blocTest<TodoBloc, TodoState>(
      'emits a failure state when loading fails',
      setUp: () {
        when(() => getTodos())
            .thenAnswer((_) async => const Err(StorageFailure('disk full')));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const TodosStarted()),
      expect: () => const [
        TodoState(status: TodoStatus.loading),
        TodoState(status: TodoStatus.failure, errorMessage: 'disk full'),
      ],
    );
  });

  group('TodoAdded', () {
    blocTest<TodoBloc, TodoState>(
      'adds the todo, then reloads the list',
      setUp: () {
        when(() => addTodo('Buy milk')).thenAnswer((_) async => const Ok(milk));
        when(() => getTodos()).thenAnswer((_) async => const Ok([milk]));
      },
      build: buildBloc,
      seed: () => const TodoState(status: TodoStatus.success),
      act: (bloc) => bloc.add(const TodoAdded('Buy milk')),
      expect: () => const [
        TodoState(status: TodoStatus.success, todos: [milk]),
      ],
      verify: (_) {
        verify(() => addTodo('Buy milk')).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'exposes the failure message when the use case rejects the input',
      setUp: () {
        when(() => addTodo('')).thenAnswer(
          (_) async => const Err(ValidationFailure('Title cannot be empty.')),
        );
      },
      build: buildBloc,
      seed: () => const TodoState(status: TodoStatus.success),
      act: (bloc) => bloc.add(const TodoAdded('')),
      expect: () => const [
        TodoState(
          status: TodoStatus.success,
          errorMessage: 'Title cannot be empty.',
        ),
      ],
    );
  });

  group('TodoToggled', () {
    blocTest<TodoBloc, TodoState>(
      'toggles the todo, then reloads the list',
      setUp: () {
        when(() => toggleTodo('1')).thenAnswer((_) async => const Ok(doneMilk));
        when(() => getTodos()).thenAnswer((_) async => const Ok([doneMilk]));
      },
      build: buildBloc,
      seed: () => const TodoState(status: TodoStatus.success, todos: [milk]),
      act: (bloc) => bloc.add(const TodoToggled('1')),
      expect: () => const [
        TodoState(status: TodoStatus.success, todos: [doneMilk]),
      ],
    );
  });

  group('TodoDeleted', () {
    blocTest<TodoBloc, TodoState>(
      'deletes the todo, then reloads the list',
      setUp: () {
        when(() => deleteTodo('1')).thenAnswer((_) async => const Ok(null));
        when(() => getTodos()).thenAnswer((_) async => const Ok([]));
      },
      build: buildBloc,
      seed: () => const TodoState(status: TodoStatus.success, todos: [milk]),
      act: (bloc) => bloc.add(const TodoDeleted('1')),
      expect: () => const [TodoState(status: TodoStatus.success)],
    );
  });
}
