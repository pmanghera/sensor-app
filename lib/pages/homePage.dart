import 'package:flutter/material.dart';
import 'dart:async';
import '../channel.dart';
// import 'package:myapp/main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChannelWidget> _channels = [];
  List<int> _channelIds = [9, 21];

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
                  itemCount: _channels == null ? 0 : _channels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _channels[index];
                  })),
        ));
  }

  @override
  initState() {
    super.initState();
    updateData();
  }

  Future<Null> updateData() async {
    _channels.clear();
    List<ChannelWidget> newChannels = [];
    for (int id in _channelIds) {
      Channel res = await getChannel(id);
      newChannels.add(new ChannelWidget(res));
    }

    this.setState(() => _channels.addAll(newChannels));
  }
}
