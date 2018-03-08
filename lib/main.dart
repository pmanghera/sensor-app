import 'package:flutter/material.dart';
import 'sensor.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SensorWidget> _sensors = <SensorWidget>[];

  @override
  initState() {
    super.initState();
    getChannel().then((res) {
      setState(() => res.sensors.forEach((sensor) => _sensors.add(new SensorWidget(sensor))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new ListView(
            children: _sensors,
          ),
        ));
  }
}

class SensorWidget extends StatelessWidget {
  SensorWidget(this.sensor);
  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new ListTile(
          trailing: new Text(sensor.last.toStringAsPrecision(3),
          style: new TextStyle(
            fontSize: 20.0
          ),),
          title: new Text(sensor.name),
          subtitle: new Text(sensor.tempHistory.map((reading) => reading.toStringAsPrecision(3)).join(', ')),
    ));
  }
}
