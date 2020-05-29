import 'package:flutter/material.dart';
import 'package:fluttersamplecounter/top_page_3_0.dart';

import 'count_repository.dart';
import 'loading_widget_1.dart';

class TopPage3_1 extends StatelessWidget {
  final CountRepository _repository;

  TopPage3_1(this._repository);

  @override
  Widget build(BuildContext context) {
    return _HomePage(
      repository: _repository,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InheritedWidget BLoC Demo'),
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
    );
  }
}

class _HomePage extends StatefulWidget {
  final CountRepository repository;
  final Widget child;

  _HomePage({
    Key key,
    this.repository,
    this.child,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  static _HomePageState of(BuildContext context, {bool rebuild = true}) {
    if (rebuild) {
      return context
          .dependOnInheritedWidgetOfExactType<_MyInheritedWidget>()
          .data;
    }
    return (context
            .getElementForInheritedWidgetOfExactType<_MyInheritedWidget>()
            .widget as _MyInheritedWidget)
        .data;
  }
}

class _HomePageState extends State<_HomePage> {
  CounterLogic counterLogic;

  @override
  void initState() {
    super.initState();
    counterLogic = CounterLogic(widget.repository);
  }

  @override
  Widget build(BuildContext context) {
    return _MyInheritedWidget(
      data: this,
      child: Stack(
        children: <Widget>[
          widget.child,
          LoadingWidget1(counterLogic.isLoading),
        ],
      ),
    );
  }

  @override
  void dispose() {
    counterLogic.dispose();
    super.dispose();
  }
}

class _MyInheritedWidget extends InheritedWidget {
  final _HomePageState data;

  _MyInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class _WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('called _WidgetA#build()');
    final _HomePageState state = _HomePage.of(context);

    return Center(
      child: StreamBuilder(
        stream: state.counterLogic.value,
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
    final _HomePageState state = _HomePage.of(context, rebuild: false);

    return RaisedButton(
      onPressed: state.counterLogic.incrementCounter,
      child: Icon(Icons.add),
    );
  }
}
