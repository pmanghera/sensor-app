import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './pages/channel_page.dart';
import 'sensor_with_graph.dart';

class Channel {
  Map _jsonData;
  String _name;
  List<Sensor> _sensors = [];
  int id;
  double _latitude;
  double _longitude;
  DateTime startTime;
  DateTime endTime;
  bool startSet = false;
  bool endSet = false;
  Channel([this._name, this.id]);

  Channel.fromJson(Map jsonMap) {
    int _counter = 1;
    id = jsonMap['channel']['id'];
    _jsonData = jsonMap;
    _name = _jsonData['channel']['name'];
    _latitude = double.parse(_jsonData['channel']['latitude']);
    _longitude = double.parse(_jsonData['channel']['longitude']);
    _jsonData['channel'].forEach((key, value) {
      if (key.startsWith('field')) {
        _sensors.add(Sensor(_jsonData['channel']['field$_counter'], _counter));
        _counter++;
      }
    });
    for (Map feed in _jsonData['feeds']) {
      for (Sensor sensor in _sensors) {
        sensor.addTemp(double.parse(feed['field${sensor.fieldNum}'] ?? -0.0),
            feed['created_at']);
      }
    }
  }

  Channel.fromId(int id) {
    this.startSet = false;
    this.endSet = false;
    this.id = id;
    var res = getChannel(id);
    res.then((res) {
      _jsonData = res.jsonData;
      _name = res.name;
      _sensors = res.sensors;
      _latitude = res.location[0];
      _longitude = res.location[1];
    });
  }

  List get sensors => _sensors;
  String get name => _name;
  Map get jsonData => _jsonData;
  List<double> get location => [_latitude, _longitude];

  bool operator ==(other) => other is Channel && other.id == this.id;
  int get hashCode => id;

  Future<Channel> updatedChannel() async {
    if (!startSet && !endSet) {
      List<DateTime> dataBegins = [];
      for (Sensor sensor in _sensors) {
        dataBegins.add(sensor.tempHistory.first.time);
      }
      dataBegins.reduce(
          (value, element) => value.compareTo(element) < 0 ? value : element);

      endTime = DateTime.now();
      if (startTime == null ||
          startTime.difference(endTime).abs() > Duration(hours: 24) ||
          dataBegins[0].difference(endTime).abs() < Duration(hours: 24)) {
        startTime = endTime.subtract(Duration(hours: 24));
      }
    } else if (!startSet && endSet) {
      startTime = endTime.subtract(Duration(hours: 24));
    } else if (startSet && !endSet) {
      endTime = DateTime.now();
    }

    String startString = startTime
        .toUtc()
        .toIso8601String()
        .substring(0, 19)
        .replaceAll('T', '%20');
    String endString = endTime
        .toUtc()
        .toIso8601String()
        .substring(0, 19)
        .replaceAll('T', '%20');
    String url =
        'https://api.thingspeak.com/channels/$id/feeds.json?start=$startString&end=$endString';
    Stopwatch stopwatch = Stopwatch()..start();
    //! These GET requests take forever, but I think that's mostly server side.
    String jsonData = await http.read(url);
    print('GET: ${stopwatch.elapsedMilliseconds / 1000}');
    stopwatch.reset();
    Map newData = jsonDecode(jsonData);
    print('Decode: ${stopwatch.elapsedMilliseconds / 1000}');
    if (newData['feeds'].isEmpty) {
      url = 'https://api.thingspeak.com/channels/$id/feeds.json';
      newData = jsonDecode(await http.read(url));
    }
    sensors.forEach((sensor) => sensor.tempHistory.clear());
    for (Sensor sensor in _sensors) {
      sensor.tempHistory.removeWhere((entry) =>
          entry.time.compareTo(
              startSet ? startTime : endTime.subtract(Duration(hours: 24))) <
          0);
    }
    stopwatch.reset();
    for (Map feed in newData['feeds']) {
      String createdAt = feed['created_at'];
      for (Sensor sensor in _sensors) {
        sensor.addTemp(
            double.tryParse(feed['field${sensor.fieldNum}'] ?? 'NaN') ?? -0.0,
            createdAt);
      }
    }
    print('Parse: ${stopwatch.elapsedMilliseconds / 1000}');
    if (!startSet) startTime = endTime;
    return this;
  }
}

Future<Channel> getChannel(int channelId) async {
  String url =
      'https://api.thingspeak.com/channels/$channelId/feeds.json?days=1';
  Map data = {};
  try {
    data = jsonDecode((await http.get(url)).body);
  } on TypeError {
    throw InvalidChannelException('Channel $channelId DNE or is private.');
  }
  if (data['feeds'].isEmpty) {
    url = 'https://api.thingspeak.com/channels/$channelId/feeds.json?';
    data = jsonDecode((await http.get(url)).body);
  }
  try {
    return Channel.fromJson(data);
  } catch (e) {
    print(e);
    throw InvalidChannelException('Channel $channelId could not be parsed');
  }
}

class ChannelWidget extends StatelessWidget {
  ChannelWidget(this.channel);
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(channel.name),
        subtitle: Text(
          'Last updated: ${channel.sensors.last.lastUpdatedPretty}',
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ChannelPage(channel))),
      ),
    );
  }
}

class InvalidChannelException implements Exception {
  final String message;
  InvalidChannelException(this.message);
  String toString() => 'InvalidChannelException: $message';
}
