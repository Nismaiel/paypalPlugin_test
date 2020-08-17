import 'package:flutter/material.dart';
import 'package:paybal_integragtion/screens/First.dart';
import 'package:paybal_integragtion/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Paybal',
        home: First());
  }
}
