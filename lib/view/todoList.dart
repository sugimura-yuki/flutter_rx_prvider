import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/todoListController.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      builder: (context, child) {
        final listController = context.read<TodoListController>();
        return Scaffold(
          appBar: AppBar(
            title: Text("TODOリスト"),
          ),
          body: Column(
            children: [
              _Form(),
              Expanded(
                child: StreamBuilder<List<Todo>>(
                  stream: listController.list,
                  builder: (context, snapshot) => _list(snapshot.data ?? []),
                ),
              ),
            ],
          ),
        );
      },
      providers: [
        Provider<TodoListController>(
          create: (_) => TodoListController(),
          dispose: (_, controller) => controller.dispose(),
        ),
        Provider<TodoFormController>(
          create: (_) => TodoFormController(),
          dispose: (_, controller) => controller.dispose(),
        ),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listController = context.read<TodoListController>();
    final formController = context.read<TodoFormController>();
    final key = GlobalKey<FormState>();
    return Form(
      key: key,
      child: Column(
        children: [
          TextFormField(
            initialValue: null,
            onSaved: formController.changeTitle,
          ),
          TextFormField(
            initialValue: null,
            onSaved: formController.changeContent,
          ),
          FormField<DateTime>(
            initialValue: null,
            onSaved: formController.changeDueTo,
            builder: (state) => ElevatedButton(
              child: Text(state.value?.toString() ?? "締切日を選択"),
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now(),
                );
                state.didChange(selected);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final state = key.currentState;
              state?.save();
              listController.addTodo(formController.todo);
              state?.reset();
            },
            child: Text("投稿"),
          )
        ],
      ),
    );
  }
}

_list(List<Todo> list) {
  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (context, idx) => _detail(list[idx]),
  );
}

_detail(Todo todo) {
  return Card(
    child: Column(
      children: [
        Text(todo.title),
        Text(todo.content),
        Text(todo.dueTo?.toString() ?? ""),
      ],
    ),
  );
}
