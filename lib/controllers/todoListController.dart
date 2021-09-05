import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class TodoListController {
  final _list = BehaviorSubject<List<Todo>>.seeded([
    Todo(title: "初期値", content: "こんてんと"),
  ]);

  Stream<List<Todo>> get list => _list.stream;

  addTodo(Todo todo) {
    final value = _list.value;
    value.add(todo);
    _list.value = value;
  }

  dispose() {
    _list.close();
  }
}

class TodoFormController {
  // Subjects
  final _title = BehaviorSubject<String?>();
  final _content = BehaviorSubject<String?>();
  final _dueTo = BehaviorSubject<DateTime?>();

  Function(String?) get changeTitle => _title.add;
  Function(String?) get changeContent => _content.add;
  Function(DateTime?) get changeDueTo => _dueTo.add;

  /// Return Current Form Value
  Todo get todo => Todo(
        title: _title.valueOrNull ?? "",
        content: _content.valueOrNull ?? "",
        dueTo: _dueTo.valueOrNull,
      );

  dispose() {
    _title.close();
    _content.close();
    _dueTo.close();
  }
}

@immutable
class Todo {
  final String title;
  final String content;
  final DateTime? dueTo;
  Todo({required this.title, required this.content, this.dueTo});
}
