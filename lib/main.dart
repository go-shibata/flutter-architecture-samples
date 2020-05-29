import 'package:flutter/material.dart';
import 'package:fluttersamplecounter/count_repository.dart';
import 'package:fluttersamplecounter/top_page_0.dart';
import 'package:fluttersamplecounter/top_page_1.dart';
import 'package:fluttersamplecounter/top_page_2.dart';
import 'package:fluttersamplecounter/top_page_3.dart';
import 'package:fluttersamplecounter/top_page_3_0.dart';
import 'package:fluttersamplecounter/top_page_3_1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('setState の場合'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage0(),
                    fullscreenDialog: true,
                  ));
            },
          ),
          ListTile(
            title: const Text('InheritedWidget の場合'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage1(),
                    fullscreenDialog: true,
                  ));
            },
          ),
          ListTile(
            title: const Text('InheritedModel の場合'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage2(),
                    fullscreenDialog: true,
                  ));
            },
          ),
          ListTile(
            title: const Text('StreamBuilder(BLoc) の場合'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage3_0(),
                    fullscreenDialog: true,
                  ));
            },
          ),
          ListTile(
            title: const Text('BLoc + InheritedWidget の場合'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage3_1(CountRepository()),
                    fullscreenDialog: true,
                  ));
            },
          ),
          ListTile(
            title: const Text('BLoc + Provider の場合'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopPage3(CountRepository()),
                    fullscreenDialog: true,
                  ));
            },
          ),
        ],
      ),
    );
  }
}
