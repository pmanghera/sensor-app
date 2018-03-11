import 'package:flutter/material.dart';
import 'dart:async';
import '../channel.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  _MyHomePageState createState() => new _MyHomePageState();
  static void setChannel(int){
    _MyHomePageState.channelIds.add(435497);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<ChannelWidget> _channels = [];
  static List<int> channelIds = [9, 21,];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("/input page");
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
    for (int id in channelIds) {
      Channel res = await getChannel(id);
      newChannels.add(new ChannelWidget(res));
    }

    this.setState(() => _channels.addAll(newChannels));
  }
}
