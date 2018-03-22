import 'dart:convert';
import 'package:http/http.dart' as http;
import 'sensor.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import './pages/channelPage.dart';

class Channel {
  Map _jsonData;
  String _name;
  List<Sensor> _sensors = [];
  int id;
  double _latitude;
  double _longitude;
  Channel([this._name, this.id]);

  Channel.fromJson(Map jsonMap) {
    int _counter = 1;
    this.id = jsonMap['channel']['id'];
    _jsonData = jsonMap;
    _name = _jsonData['channel']['name'];
    _latitude = double.parse(_jsonData['channel']['latitude']);
    _longitude = double.parse(_jsonData['channel']['longitude']);
    _jsonData['channel'].forEach((key, value) {
      if (key.startsWith('field')) {
        _sensors
            .add(new Sensor(_jsonData['channel']['field$_counter'], _counter));
        _counter++;
      }
    });
    for (Map feed in _jsonData['feeds']) {
      for (Sensor sensor in _sensors) {
        // Let's try to find a better way to handle null
        sensor.addTemp(
            feed['field${sensor.fieldNum}'] == null
                ? -0.0
                : double.parse(feed['field${sensor.fieldNum}']),
            feed['created_at']);
      }
    }
  }

  Channel.fromId(int id) {
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
}

Future<Channel> getChannel([int channelId = 9, int results = 10]) async {
  String url =
      'https://api.thingspeak.com/channels/$channelId/feeds.json?results=$results';
      try{
  return http
      .get(url)
      .then((res) => (new Channel.fromJson(JSON.decode(res.body) as Map)));
      }
      catch (e) {
        return new Channel('Error');
      }
}

class ChannelWidget extends StatelessWidget {
  ChannelWidget(this.channel);
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new ListTile(
      title: new Text(channel.name),
      subtitle: new Text(
        'Last updated: ${channel.sensors.last.lastUpdatedPretty}',
      ),
      onTap: () => Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new ChannelPage(channel))),
    ));
  }
}

/// For testing purposes only
main() {
  Future<Channel> test = getChannel();
  test.then((res) => res._sensors.forEach((sensor) => print(sensor)));
}
