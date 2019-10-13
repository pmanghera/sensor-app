import 'dart:async';
import 'package:flutter/material.dart';
import '../channel.dart';
import '../sensor_with_graph.dart';
import '../time_range_picker.dart';

class ChannelPage extends StatefulWidget {
  ChannelPage(this.channel);
  final Channel channel;
  _ChannelPageState createState() => _ChannelPageState(channel);
}

class _ChannelPageState extends State<ChannelPage> {
  _ChannelPageState(this.channel);
  Channel channel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(channel.name),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              icon: Icon(Icons.timelapse),
              onPressed: () async {
                List timeRange = await (Navigator.push(
                    context,
                    MaterialPageRoute<List>(
                      builder: (BuildContext context) => DateAndTimePickerDemo(
                            fromSet: channel.startSet,
                            fromDate: channel.startTime,
                          ),
                    )));
                if (timeRange != null) {
                  setState(() {
                    if (timeRange.isEmpty) {
                      channel.startSet = false;
                      channel.endSet = false;
                    } else {
                      if (timeRange[0] == null) {
                        channel.startSet = false;
                      } else {
                        channel.startTime = timeRange[0];
                        channel.startSet = true;
                      }
                      if (timeRange[1] == null) {
                        channel.endSet = false;
                      } else {
                        channel.endTime = timeRange[0];
                        channel.endSet = true;
                      }
                    }
                  });
                }
                updateChannel();
              },
            ),
          )
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: updateChannel,
          child: ListView.builder(
            itemCount: channel.sensors == null ? 0 : channel.sensors.length,
            itemBuilder: (BuildContext context, int index) =>
                SensorWidget(context, channel.sensors[index]),
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    updateChannel();
  }

  Future<Null> updateChannel() async {
    Channel newChannel = await channel.updatedChannel();
    setState(() => channel = newChannel);
  }
}
