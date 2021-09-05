import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/homepage.dart';
import 'package:flutter_application_1/view/todoList.dart';

void main() {
  runApp(_app);
}

final _app = MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  initialRoute: 'todo.list',
  routes: <String, WidgetBuilder>{
    'home': (_) => MyHomePage(title: 'Flutter Demo Home Page'),
    'todo.list': (_) => TodoList(),
  },
);
