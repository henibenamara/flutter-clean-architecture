import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/pages/todo_page.dart';
import 'package:flutter_clean_architecture/injection.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Architecture Todos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: BlocProvider(
        create: (_) => sl<TodoBloc>()..add(const TodosStarted()),
        child: const TodoPage(),
      ),
    );
  }
}
