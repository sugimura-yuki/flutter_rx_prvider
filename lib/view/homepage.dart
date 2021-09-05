import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (_) => Counter(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: _Content(),
        floatingActionButton: _IncrementButton(),
      ),
    );
  }
}

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          _CounterText(),
        ],
      ),
    );
  }
}

class _CounterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Counter>(
      builder: (BuildContext context, Counter counter, Widget? child) => Text(
        '${counter.count}',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

class _IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context, listen: false);
    return FloatingActionButton(
      onPressed: counter.increment,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}
