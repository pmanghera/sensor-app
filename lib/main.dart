import 'package:flutter/material.dart';
import './pages/home_page.dart';
import 'input_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sensor Monitor',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.redAccent,
        ),
        home: MyHomePage(title: 'Sensor Monitor'),
        routes: <String, WidgetBuilder>{
          "/input page": (BuildContext context) => TextInput()
        });
  }
}
