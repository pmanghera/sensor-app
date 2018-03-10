import 'package:flutter/material.dart';
// import 'date'

class Sensor {
  String _name;
  List<double> _tempHistory = [];
  int _fieldNum;
  DateTime _lastUpdated;
  Sensor(this._name, this._fieldNum);

  void addTemp(double newTemp, [String time]) {
    _tempHistory.add(newTemp);
    _lastUpdated = DateTime.parse(time);
  }

  int get fieldNum => _fieldNum;
  String get name => _name;
  List get tempHistory => _tempHistory;
  double get last => _tempHistory.last;
  DateTime get lastUpdated => _lastUpdated;

  String toString() {
    return '$_name: ${(_tempHistory.last).toStringAsPrecision(3)}';
  }
}

class SensorWidget extends StatelessWidget {
  SensorWidget(this.sensor);
  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new ListTile(
            trailing: new Text(
              sensor.last.toStringAsPrecision(3),
              style: new TextStyle(fontSize: 20.0),
            ),
            title: new Text(sensor.name),
            subtitle: new Text('Last updated: ${sensor.lastUpdated.toLocal().toString()}')));
  }
}
