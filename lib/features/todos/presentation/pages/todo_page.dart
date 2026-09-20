import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/todos/presentation/bloc/todo_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: BlocListener<TodoBloc, TodoState>(
        listenWhen: (previous, current) =>
            current.errorMessage != null &&
            current.errorMessage != previous.errorMessage,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        },
        child: const Column(
          children: [
            Expanded(child: _TodoList()),
            _AddTodoBar(),
          ],
        ),
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state.status == TodoStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.todos.isEmpty) {
          final message = state.status == TodoStatus.failure
              ? (state.errorMessage ?? 'Something went wrong.')
              : 'Nothing to do yet. Add a task below.';
          return Center(child: Text(message));
        }
        return ListView.builder(
          itemCount: state.todos.length,
          itemBuilder: (context, index) {
            final todo = state.todos[index];
            return ListTile(
              key: ValueKey(todo.id),
              leading: Checkbox(
                value: todo.isDone,
                onChanged: (_) {
                  context.read<TodoBloc>().add(TodoToggled(todo.id));
                },
              ),
              title: Text(
                todo.title,
                style: todo.isDone
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              trailing: IconButton(
                tooltip: 'Delete',
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  context.read<TodoBloc>().add(TodoDeleted(todo.id));
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _AddTodoBar extends StatefulWidget {
  const _AddTodoBar();

  @override
  State<_AddTodoBar> createState() => _AddTodoBarState();
}

class _AddTodoBarState extends State<_AddTodoBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<TodoBloc>().add(TodoAdded(_controller.text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('add_todo_field'),
                controller: _controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  hintText: 'What needs doing?',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              key: const Key('add_todo_button'),
              tooltip: 'Add task',
              onPressed: _submit,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
