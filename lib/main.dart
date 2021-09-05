import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/homepage.dart';
import 'package:flutter_application_1/view/todoList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'todo.list',
      routes: <String, WidgetBuilder>{
        'home': (BuildContext context) =>
            MyHomePage(title: 'Flutter Demo Home Page'),
        'todo.list': (BuildContext context) => TodoList(),
      },
    );
  }
}
