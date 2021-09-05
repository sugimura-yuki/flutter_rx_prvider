import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/todoListController.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: Scaffold(
        appBar: AppBar(title: Text("TODOリスト")),
        body: _Body(),
      ),
      // ここで生成されたインスタンスが子Widgetで利用可能になる
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

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final listController = context.read<TodoListController>();
    return Column(
      children: [
        _Form(),
        Expanded(
          child: StreamBuilder<List<Todo>>(
            stream: listController.list,
            builder: (context, snapshot) => _list(snapshot.data ?? []),
          ),
        ),
      ],
    );
  }
}

class _Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FormのKeyを作成
    final key = GlobalKey<FormState>();

    // 親WidgetであるMultiProviderで生成されたインスタンスを読み取る
    final listController = context.read<TodoListController>();
    final formController = context.read<TodoFormController>();

    return Form(
      key: key,
      child: Column(
        children: [
          // タイトル入力欄
          TextFormField(
            onSaved: formController.changeTitle,
            decoration: InputDecoration(labelText: "タイトル"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "タイトルは必須です";
              }
            },
          ),
          // 内容入力欄
          TextFormField(
            onSaved: formController.changeContent,
            decoration: InputDecoration(labelText: "内容"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "内容は必須です";
              }
            },
          ),
          // 締切日選択
          FormField<DateTime>(
            onSaved: formController.changeDueTo,
            builder: (state) => Row(
              children: [
                Text(state.value?.toString() ?? "締切日を選択"),
                IconButton(
                  onPressed: () => _selectDueTo(context, state),
                  icon: Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
          // 投稿ボタン
          ElevatedButton(
            onPressed: () {
              final state = key.currentState;
              if (state == null) throw NullThrownError();

              // 入力チェック
              if (!state.validate()) return;

              // Formの入力内容を保存
              state.save();

              // Formの内容を一覧に追加
              final todo = formController.todo;
              listController.addTodo(todo);

              // Fromの内容を初期化
              state.reset();
            },
            child: Text("投稿"),
          )
        ],
      ),
    );
  }

  _selectDueTo(BuildContext context, FormFieldState<DateTime> state) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    state.didChange(selected);
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
