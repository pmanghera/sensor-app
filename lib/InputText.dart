import 'package:flutter/material.dart';
import './pages/homePage.dart';

class TextInput extends StatefulWidget{
  @override
  TextInputState createState() => new TextInputState();
}

class TextInputState extends State<TextInput>{

  String result ="";
  String sensorName;
  static String serialNumber = '0';
  String minTemp;
  String maxTemp;
  int channelID = int.parse(serialNumber);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: new AppBar(title: new Text("Adding a Sensor")),
        body: new Container(
            padding: const EdgeInsets.all(32.0),
            child: new Center(
                child: new ListView(
                  shrinkWrap: true,
                    padding: const EdgeInsets.all(20.0),
                    children: <Widget>[
                      new Container(
                          padding: const EdgeInsets.all(10.0),
                        child:new TextField(
                            decoration: new InputDecoration(
                            hintText: "Type Sensor Name Here"
                        ),
                          onChanged: (String str) {
                            setState(() {
                              sensorName = str;
                            });
                          }
                      )
                      ),
                      new Container(
                        padding: const EdgeInsets.all(10.0),
                          child: new TextField(
                              decoration: new InputDecoration(
                                  hintText: "Type Sensor Serial Number Here"
                              ),
                              onChanged: (String str) {
                                setState(() {
                                  serialNumber = str;
                                });
                              }
                          )
                      ),
                      new Container(
                        padding: const EdgeInsets.all(10.0),
                        child: new TextField(
                            decoration: new InputDecoration(
                                hintText: "Type Minumum Alert Temperature Here"
                            ),
                            onChanged: (String str) {
                              setState(() {
                                minTemp = str;
                              });
                            }
                        ),
                      ),
                      new Container(
                        padding: const EdgeInsets.all(10.0),
                        child:new TextField(
                            decoration: new InputDecoration(
                                hintText: "Type Maximum Alert Temperature Here"
                            ),
                            onChanged: (String str) {
                              setState(() {
                                 maxTemp = str;
                              });
                            }
                        ),
                      ),
                      new RaisedButton(
                          child: new Text("Add Sensor") ,
                          onPressed: () {
                            // MyHomePage.addChannelId(int.parse(serialNumber));
                            Navigator.of(context).pop(int.parse(serialNumber));
                          }
                      )
                    ]
                )
            )
        )
    );

  }
}