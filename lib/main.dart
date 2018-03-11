import 'package:flutter/material.dart';
import './pages/homePage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sensor Monitor',
      theme: new ThemeData(brightness: Brightness.dark),
      home: new MyHomePage(title: 'Sensor Monitor'),
    );
  }
}
