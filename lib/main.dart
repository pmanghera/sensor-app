import 'package:flutter/material.dart';
import 'sensor.dart';
import 'dart:async';
import 'channel.dart';

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
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.refresh),
          onPressed: () {
            // This is redundant now
            // change to add Channel or remove
            updateData();
          },
        ),
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new RefreshIndicator(
              onRefresh: (() => updateData()),
              child: new ListView.builder(
                  itemCount: _sensors == null ? 0 : _sensors.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _sensors[index];
                  })),
        ));
  }

  @override
  initState() {
    super.initState();
    updateData();
  }

  Future<Null> updateData() async {
    _sensors.clear();
    var res = await getChannel();
    this.setState(() => res.sensors
        .forEach((sensor) => _sensors.add(new SensorWidget(sensor))));
    print(_sensors.last.sensor.tempHistory.last.toStringAsPrecision(3));
  }
}
