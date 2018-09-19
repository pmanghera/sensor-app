import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<TimeSeriesPoint> _tempHistory = [];
  int _fieldNum;
  DateTime _lastUpdated;
  Sensor(this._name, this._fieldNum, {this.minVal, this.maxVal});
  double minVal, maxVal;

  void addTemp(double newTemp, [String time]) {
    _tempHistory.add(TimeSeriesPoint(DateTime.parse(time).toLocal(), newTemp));
    _lastUpdated = DateTime.parse(time).toLocal();
  }

  int get fieldNum => _fieldNum;
  String get name => _name;
  List get tempHistory => _tempHistory;
  DateTime get lastUpdated => _lastUpdated;
  String get lastUpdatedPretty =>
      '${monthNames[_lastUpdated.month - 1]} ${_lastUpdated.day} at ${_lastUpdated.hour % 12 == 0 ? 12 : _lastUpdated.hour % 12}:${_lastUpdated.minute < 10 ? "0" + lastUpdated.minute.toString() : lastUpdated.minute} ${_lastUpdated.hour > 12 ? "PM" : "AM"}';

  String toString() {
    return '$_name: ${(_tempHistory.last.value).toStringAsPrecision(3)}';
  }
}

class SensorWidget extends StatelessWidget {
  SensorWidget(this.context, this.sensor);
  final Sensor sensor;
  final BuildContext context;

  List<charts.Series<TimeSeriesPoint, DateTime>> _createSampleData() {
    return [
      charts.Series<TimeSeriesPoint, DateTime>(
        id: '${sensor.name}',
        colorFn: (_, __) => charts.Color(
              r: Theme.of(context).accentColor.red,
              g: Theme.of(context).accentColor.green,
              b: Theme.of(context).accentColor.blue,
            ),
        domainFn: (TimeSeriesPoint points, _) => points.time,
        measureFn: (TimeSeriesPoint points, _) => points.value,
        data: sensor.tempHistory,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: RichText(
          text: TextSpan(
              text: '${sensor.name}\n',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Current: ${sensor.tempHistory.last.value.toStringAsPrecision(3)}',
                    style: TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.normal))
              ]),
        ),
        isThreeLine: true,
        subtitle: SizedBox(
          height: 250.0,
          child: charts.TimeSeriesChart(
            _createSampleData(),
            animate: true,
            dateTimeFactory: charts.LocalDateTimeFactory(),
            domainAxis: charts.DateTimeAxisSpec(
              tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                hour: charts.TimeFormatterSpec(
                  format: 'h',
                ),
              ),
              tickProviderSpec:
                  charts.StaticDateTimeTickProviderSpec(_getTimeTicks()),
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
              ),
            ),
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                desiredTickCount: 6,
              ),
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<charts.TickSpec<DateTime>> _getTimeTicks() {
    DateTime startTime = sensor.tempHistory[0].time;
    List<DateTime> times = [startTime];
    DateFormat formatter = DateFormat.Hm();
    Duration range = sensor.tempHistory.last.time.difference(startTime);
    Duration spacing = Duration(milliseconds: range.inMilliseconds ~/ 8);
    for (int i = 0; i < 7; i++) {
      times.add(times.last.add(spacing));
    }
    times.add(sensor.tempHistory.last.time);

    return times
        .map((time) => charts.TickSpec<DateTime>(
              time,
              label: formatter.format(time),
            ))
        .toList();
  }
}

class TimeSeriesPoint {
  final DateTime time;
  final double value;

  TimeSeriesPoint(this.time, this.value);
}
