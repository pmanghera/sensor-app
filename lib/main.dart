import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';
// import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Data(),
      ),
    );
  }
}

class Data extends StatefulWidget {
  @override
  createState() => new DataState();
}

class DataState extends State<Data> {
  Map _channelData;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: _channelData == null ? 0 : _channelData.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          child: new Text(_channelData['feeds'][index]['field1']),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  Future<Map> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull(
            'https://api.thingspeak.com/channels/9/feeds.json?results=2'),
        headers: {"Accept": "application/json"});
    Map data = JSON.decode(response.body);
    print(data);

    this.setState(() {
      _channelData = data;
    });
    return data;
  }
}
