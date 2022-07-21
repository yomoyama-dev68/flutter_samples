import 'dart:async';

import 'package:flutter/material.dart';
import 'bloc_base.dart';

void main() {
  runApp(const MyApp());
}

class BlocMain extends BlocBase {
  final onCountChange = StreamController<int>();
  int count = 0;

  BlocMain() {
    onCountChange.add(count);
  }

  void countUp() {
    ++count;
    onCountChange.add(count);
  }

  @override
  void dispose() {
    onCountChange.close();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc base demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Bloc base demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocHolder(
        blocBuilder: () => BlocMain(),
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    const Text('You have pushed the button this many times:'),
                    StreamBuilder(
                        stream: BlocHolder.blocOf<BlocMain>(context)!
                            .onCountChange
                            .stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<int> snapShot) {
                          return Text(
                            '${snapShot.data}',
                            style: Theme.of(context).textTheme.headline4,
                          );
                        })
                  ])),
              floatingActionButton: FloatingActionButton(
                onPressed: BlocHolder.blocOf<BlocMain>(context)!.countUp,
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ));
        }));
  }
}
