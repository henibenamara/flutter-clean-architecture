import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/todos/data/datasources/in_memory_todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todos/data/models/todo_model.dart';
import 'package:flutter_clean_architecture/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/add_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/delete_todo.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/get_todos.dart';
import 'package:flutter_clean_architecture/features/todos/domain/usecases/toggle_todo.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/pages/todo_page.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests wire the real layers together (in-memory data source), so
/// they exercise the whole vertical slice from tap to rendered list.
void main() {
  Widget buildApp() {
    final dataSource = InMemoryTodoLocalDataSource(
      initial: const [TodoModel(id: '1', title: 'Buy milk')],
    );
    final repository = TodoRepositoryImpl(dataSource);
    return MaterialApp(
      home: BlocProvider(
        create: (_) => TodoBloc(
          getTodos: GetTodos(repository),
          addTodo: AddTodo(repository),
          toggleTodo: ToggleTodo(repository),
          deleteTodo: DeleteTodo(repository),
        )..add(const TodosStarted()),
        child: const TodoPage(),
      ),
    );
  }

  testWidgets('shows the todos it loads', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('adds a todo typed by the user', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('add_todo_field')),
      'Write tests',
    );
    await tester.tap(find.byKey(const Key('add_todo_button')));
    await tester.pumpAndSettle();

    expect(find.text('Write tests'), findsOneWidget);
    expect(find.text('Buy milk'), findsOneWidget);
  });

  testWidgets('shows the validation message for a blank title', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_todo_button')));
    await tester.pumpAndSettle();

    expect(find.text('Title cannot be empty.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('marks a todo as done', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('deletes a todo', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsNothing);
    expect(find.text('Nothing to do yet. Add a task below.'), findsOneWidget);
  });
}
