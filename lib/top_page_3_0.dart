import 'dart:async';

import 'package:flutter/material.dart';

import 'count_repository.dart';
import 'loading_widget_1.dart';

class CounterLogic {
  final CountRepository _repository;
  final _valueController = StreamController<int>();
  final _loadingController = StreamController<bool>();

  Stream<int> get value => _valueController.stream;

  Stream<bool> get isLoading => _loadingController.stream;

  int _counter = 0;

  CounterLogic(this._repository) {
    _valueController.sink.add(_counter);
    _loadingController.sink.add(false);
  }

  void incrementCounter() async {
    _loadingController.sink.add(true);
    var increaseCount = await _repository.fetch().whenComplete(() {
      _loadingController.sink.add(false);
    });
    _counter += increaseCount;
    _valueController.sink.add(_counter);
  }

  void dispose() {
    _valueController.close();
    _loadingController.close();
  }
}

class TopPage3_0 extends StatefulWidget {
  @override
  _TopPage3_0State createState() => _TopPage3_0State();
}

class _TopPage3_0State extends State<TopPage3_0> {
  CounterLogic counterLogic;

  @override
  void initState() {
    super.initState();
    counterLogic = CounterLogic(CountRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text('BLoc Simple Demo'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _WidgetA(counterLogic),
              _WidgetB(),
              _WidgetC(counterLogic),
            ],
          ),
        ),
        LoadingWidget1(counterLogic.isLoading),
      ],
    );
  }

  @override
  void dispose() {
    counterLogic.dispose();
    super.dispose();
  }
}

class _WidgetA extends StatelessWidget {
  final CounterLogic counterLogic;

  _WidgetA(this.counterLogic);

  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    return Center(
      child: StreamBuilder(
        stream: counterLogic.value,
        builder: (context, snapshot) {
          return Text(
            '${snapshot.data}',
            style: Theme.of(context).textTheme.display1,
          );
        },
      ),
    );
  }
}

class _WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetB#build()');
    return const Text('I am a widget that will not be rebuilt.');
  }
}

class _WidgetC extends StatelessWidget {
  final CounterLogic counterLogic;

  _WidgetC(this.counterLogic);

  @override
  Widget build(BuildContext context) {
    print('called _WidgetC#build()');
    return RaisedButton(
      onPressed: counterLogic.incrementCounter,
      child: Icon(Icons.add),
    );
  }
}
