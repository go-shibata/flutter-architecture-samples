import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttersamplecounter/count_repository.dart';
import 'package:fluttersamplecounter/loading_widget_3.dart';
import 'package:provider/provider.dart';

class LoadingBloc {
  final _valueController = StreamController<bool>();

  Stream<bool> get value => _valueController.stream;

  LoadingBloc() {
    loading(false);
  }

  void loading(bool isLoading) {
    _valueController.sink.add(isLoading);
  }

  void dispose() {
    _valueController.close();
  }
}

class CounterBloc {
  final CountRepository _repository;
  final LoadingBloc _loadingBloc;

  final _valueController = StreamController<int>();

  Stream<int> get value => _valueController.stream;

  int _counter = 0;

  CounterBloc(this._repository, this._loadingBloc) {
    _valueController.sink.add(_counter);
  }

  void incrementCounter() async {
    _loadingBloc.loading(true);
    var increaseCount = await _repository.fetch().whenComplete(() {
      _loadingBloc.loading(false);
    });
    _counter += increaseCount;
    _valueController.sink.add(_counter);
  }

  void dispose() {
    _valueController.close();
  }
}

class TopPage3 extends StatelessWidget {
  final CountRepository _repository;

  TopPage3(this._repository);

  @override
  Widget build(BuildContext context) {
    // 階層の上位に `Provider`
    // BLoC のインスタンス化も dispose も Provider の関数内で呼ぶ
    return MultiProvider(
      providers: [
        Provider<LoadingBloc>(
          create: (_) => LoadingBloc(),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<CounterBloc>(
          create: (context) {
            final bloc = Provider.of<LoadingBloc>(context, listen: false);
            return CounterBloc(_repository, bloc);
          },
          dispose: (_, bloc) => bloc.dispose(),
        )
      ],
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: const Text('BLoC Demo'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _WidgetA(),
                _WidgetB(),
                _WidgetC(),
              ],
            ),
          ),
          const LoadingWidget3(),
        ],
      ),
    );
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    // Provider.of で BLoC を取得できる
    // StreamBuilder で Stream を listen しているので
    //  CounterBLoc 自体を listen する必要はない（service provider として利用）
    final bloc = Provider.of<CounterBloc>(context, listen: false);

    return Center(
      child: StreamBuilder<int>(
        stream: bloc.value,
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
  @override
  Widget build(BuildContext context) {
    print('called _WidgetC#build()');
    final bloc = Provider.of<CounterBloc>(context, listen: false);

    return RaisedButton(
      onPressed: bloc.incrementCounter,
      child: Icon(Icons.add),
    );
  }
}
