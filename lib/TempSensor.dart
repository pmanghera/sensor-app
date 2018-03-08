import 'package:flutter/material.dart';

class TempSensor extends StatelessWidget{
  TempSensor({this.title, this.maxTemp, this.minTemp, this.serialNumber, this.currentTemp});

   String title;
   String minTemp;
   String maxTemp;
   String serialNumber;
   String currentTemp;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(15.0),
      child: new Container(
          padding: const EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: Colors.blue)
          ),
          child: new Center(
            child: new Row(
              children: <Widget>[
                new CircleAvatar(
                  child: new Text('12'),
                ),
                new Expanded(
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        this.title,
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                      new Text(serialNumber),
                      new Text("alert at " + minTemp + " degrees and " + maxTemp + " degrees")
                    ],
                  ),
                )

              ],
            ),
          )
      )
        );
  }
}






