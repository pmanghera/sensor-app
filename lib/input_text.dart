import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  String result = "";
  String sensorName;
  static String serialNumber = '0';
  String minTemp;
  String maxTemp;
  int channelID = int.parse(serialNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adding a Sensor")),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration:
                      InputDecoration(hintText: "Type Sensor Name Here"),
                  onChanged: (String str) {
                    setState(() {
                      sensorName = str;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Type Sensor Serial Number Here"),
                  onChanged: (String str) {
                    setState(() {
                      serialNumber = str;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Type Minumum Alert Temperature Here"),
                  onChanged: (String str) {
                    setState(() {
                      minTemp = str;
                    });
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    decoration: InputDecoration(
                        hintText: "Type Maximum Alert Temperature Here"),
                    onChanged: (String str) {
                      setState(() {
                        maxTemp = str;
                      });
                    }),
              ),
              RaisedButton(
                child: Text("Add Sensor"),
                onPressed: () {
                  Navigator.of(context).pop({'name': sensorName, 'serialNumber': int.parse(serialNumber), 'min': minTemp, 'max': maxTemp});
                },
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
