import 'package:flutter/material.dart';

class TextInput extends StatefulWidget{
  @override
  TextInputState createState() => new TextInputState();
}

class TextInputState extends State<TextInput>{

  String result ="";
  String sensorName;
  String serialNumber;
  String minTemp;
  String maxTemp;

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
                                hintText: "Type Minumum Alret Temperature Here"
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
                                hintText: "Type Maximum Alret Temperature Here"
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
                          onPressed: null,
                      )
                    ]
                )
            )
        )
    );

  }
}