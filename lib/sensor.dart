import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Channel {
  Map _jsonData;
  String _name;
  List<Sensor> _sensors = [];

  Channel.fromJson(Map jsonMap) {
    int _counter = 1;
    _jsonData = jsonMap;
    _name = _jsonData['channel']['_name'];
    _jsonData['channel'].forEach((key, value) {
      if (key.startsWith('field')) {
        _sensors
            .add(new Sensor(_jsonData['channel']['field$_counter'], _counter));
        _counter++;
      }
    });
    for (Map feed in _jsonData['feeds']) {
      for (Sensor sensor in _sensors) {
        sensor.addTemp(double.parse(feed['field${sensor.fieldNum}']));
      }
    }
  }

  List get sensors => _sensors;
  String get name => _name;
}

Future<Channel> getChannel() async {
  String url = 'https://api.thingspeak.com/channels/9/feeds.json?results=2';
  return http
      .get(url)
      .then((res) => (new Channel.fromJson(JSON.decode(res.body) as Map)));
}

class Sensor {
  String __name;
  List<double> _tempHistory = [];
  int _fieldNum;

  Sensor(this.__name, this._fieldNum);

  void addTemp(double newTemp) {
    _tempHistory.add(newTemp);
  }

  int get fieldNum => _fieldNum;
  String get _name => __name;
  List get tempHistory => _tempHistory;
  double get last => _tempHistory.last;

  String toString() {
    return '$__name: ${(_tempHistory.last).toStringAsPrecision(3)}';
  }
}

/// For testing purposes only
main() {
  // Co-ords for Venice Beach, CA
  Future<Channel> test = getChannel();
  test.then(
      (res) => res._sensors.forEach((sensor) => print(sensor.toString())));
}
