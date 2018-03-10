import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sensor.dart';
import 'dart:async';

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
        sensor.addTemp(
            double.parse(feed['field${sensor.fieldNum}']), feed['created_at']);
      }
    }
  }

  List get sensors => _sensors;
  String get name => _name;
}

Future<Channel> getChannel([int channelId = 9, int results = 10]) async {
  String url =
      'https://api.thingspeak.com/channels/$channelId/feeds.json?results=$results';
  return http
      .get(url)
      .then((res) => (new Channel.fromJson(JSON.decode(res.body) as Map)));
}

/// For testing purposes only
main() {
  Future<Channel> test = getChannel();
  test.then((res) => res._sensors.forEach((sensor) => print(sensor)));
}