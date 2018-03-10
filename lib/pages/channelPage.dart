import 'package:flutter/material.dart';
import '../sensor.dart';
import 'dart:async';
import '../channel.dart';

class ChannelPage extends StatefulWidget {
  ChannelPage(this.channel);
  final Channel channel;
  _ChannelPageState createState() => new _ChannelPageState(channel);
}

class _ChannelPageState extends State<ChannelPage> {
  _ChannelPageState(this.channel);
  Channel channel;
  List<SensorWidget> _sensors = [];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(channel.name),
        ),
        body: new Center(
          child: new RefreshIndicator(
              onRefresh: (() => updateChannel(channel.id)),
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
    updateChannel(channel.id);
  }

  Future<Null> updateChannel(int id) async {
    _sensors.clear();
    var res = await getChannel(id);
    this.setState(() => res.sensors
        .forEach((sensor) => _sensors.add(new SensorWidget(sensor))));
    print(_sensors.last.sensor.tempHistory.last.toStringAsPrecision(3));
  }
}
