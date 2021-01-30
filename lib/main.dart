import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final EventChannel _eventChannel =
      const EventChannel('com.example.flutterengineroute/event');
  StreamSubscription<dynamic> _eventStreamSubscription;
  String _routeName = '';

  @override
  void initState() {
    super.initState();
    _routeName = window.defaultRouteName;
    _eventStreamSubscription =
        _eventChannel.receiveBroadcastStream().listen(_parseEventChannel);
    if (_routeName == 'init') {
      SystemNavigator.pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _eventStreamSubscription.cancel();
  }

  void _parseEventChannel(dynamic event) {
    if (event is Map) {
      if (event.containsKey('initial_route')) {
        dynamic routeName = event['initial_route'];
        if (routeName is String) {
          setState(() {
            _routeName = routeName;
          });
        }
      }
    }
  }

  //instead of using multiple MaterialApp, use channel event to update the initail route(here _routeName)
  //and pass the initial route value to material app as commented below.
  @override
  Widget build(BuildContext context) {
    switch (_routeName) {
      case 'anotherRoute':
        return MaterialApp(
          //initialRoute: _routeName,
          home: Scaffold(
            body: Center(
              child: Text('This is another Flutter route'),
            ),
          ),
        );
      case 'counter':
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: MyHomePage(title: 'Flutter Demo Home Page'),
        );
      default:
        return Container();
    }
  }
}

Widget MyHomePage({String title}) {
  return Center(
    child: Text(title),
  );
}
