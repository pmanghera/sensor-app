import 'package:flutter/material.dart';
import './pages/homePage.dart';
<<<<<<< HEAD
=======
import './pages/channelPage.dart';
import 'InputText.dart';
>>>>>>> 0ae362a24925c7bf3d6fd62feeaa7a920c512c48

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sensor Monitor',
      theme: new ThemeData(brightness: Brightness.dark),
      home: new MyHomePage(title: 'Sensor Monitor'),
      routes: <String, WidgetBuilder> {
        "/input page": (BuildContext context) => new TextInput()
      }
    );
  }
}
