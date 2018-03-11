import 'package:flutter/material.dart';

List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

class Sensor {
  String _name;
  List<double> _tempHistory = [];
  int _fieldNum;
  DateTime _lastUpdated;
  Sensor(this._name, this._fieldNum);

  void addTemp(double newTemp, [String time]) {
    _tempHistory.add(newTemp);
    _lastUpdated = DateTime.parse(time).toLocal().subtract(new Duration(hours: 8));
  }

  int get fieldNum => _fieldNum;
  String get name => _name;
  List get tempHistory => _tempHistory;
  double get last => _tempHistory.last;
  DateTime get lastUpdated => _lastUpdated;
  String get lastUpdatedPretty =>
      '${monthNames[_lastUpdated.month - 1]} ${_lastUpdated.day} at ${_lastUpdated.hour % 12}:${_lastUpdated.minute < 10 ? "0" + lastUpdated.minute.toString() : lastUpdated.minute} ${_lastUpdated.hour > 12 ? "PM" : "AM"}';

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
              (sensor.last == -0.0 && sensor.last.isNegative) ? 'n/a': sensor.last.toStringAsPrecision(3),
              style: new TextStyle(fontSize: 20.0),
            ),
            title: new Text(sensor.name),
            subtitle: new Text('Last updated: ${sensor.lastUpdatedPretty}')));
  }
}
