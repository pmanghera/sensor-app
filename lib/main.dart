import 'package:flutter/material.dart';
import 'TempSensor.dart';
import 'InputText.dart';

void main(){
    runApp(
    new MaterialApp(
      home: new TempSensorBuilder(),
      routes: <String, WidgetBuilder>{
        "/text Page": (BuildContext context)=> new TextInput()
      },
    )
  );
}

class TempSensorBuilder extends StatefulWidget{
  @override
  TempSensorBuilderState createState() => new TempSensorBuilderState();
}

class TempSensorBuilderState extends State<TempSensorBuilder>{
  List<Widget> sensors = <Widget>[];

  @override
  initState(){
    super.initState();
  }

  void addSensor(){
    sensors.add( new TempSensor(
      title: 'Sensor',
      minTemp: '12',
      maxTemp: '23',
      serialNumber: '2163554',
    ));
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('Temp Sensors')),
        body: new Container(
            child: new Center(
              child: new ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  new TempSensor(
                      title: "Sensor",
                      minTemp: "12",
                      maxTemp: "23",
                      serialNumber: "2163554"
                  ),new TempSensor(
                      title: "Sensor",
                      minTemp: "12",
                      maxTemp: "23",
                      serialNumber: "2163554"
                  ),
                  new TempSensor(
                      title: "Sensor",
                      minTemp: "12",
                      maxTemp: "23",
                      serialNumber: "2163554"
                  ),
                  new RaisedButton(
                      child: new Text("Press to add more Sensors") ,
                      onPressed: () {Navigator.of(context).pushNamed("/text Page");}
                  )
                ],
              ),
            )
        )
    );
  }
}
