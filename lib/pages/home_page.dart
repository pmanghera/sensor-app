import 'dart:collection';
import 'dart:async';
import 'package:flutter/material.dart';
import '../channel.dart';
import '../file.dart';
import '../input_text.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  _MyHomePageState createState() => _MyHomePageState();
  static void addChannelId(int id) async {
    _MyHomePageState.channelIds.add(id);
    writeIdsToFile(_MyHomePageState.channelIds);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Set<Channel> _channels = SplayTreeSet(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  static Set<int> channelIds = Set();

  Timer updater;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: buildButton,
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: updateData,
          child: ListView.builder(
            itemCount: _channels.length,
            itemBuilder: ((BuildContext context, int index) {
              return Dismissible(
                key: Key(index.toString()),
                child: ChannelWidget(_channels.elementAt(index)),
                onDismissed: (DismissDirection direction) {
                  Channel temp = _channels.elementAt(index);
                  setState(() {
                    channelIds.remove(_channels.elementAt(index).id);
                    _channels.remove(_channels.elementAt(index));
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Removed ${temp.name}'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            setState(() {
                              _channels.add(temp);
                              channelIds.add(temp.id);
                            });
                          },
                        ),
                        backgroundColor: Colors.black38,
                      ));
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  // This needs its own build method in order to use the snackbar.
  // 'Why?', you ask... I don't know. I didn't develop Flutter.
  Widget buildButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        int newId = ((await Navigator.push(
                context,
                MaterialPageRoute<Map>(
                  builder: (BuildContext context) => TextInput(),
                  fullscreenDialog: true,
                ))) ??
            {'serialNumber': -1})['serialNumber'];
        try {
          await addChannel(newId);
        } on InvalidChannelException catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.black38,
                duration: Duration(seconds: 5),
              ));
        }
        writeIdsToFile(channelIds);
      },
    );
  }

  @override
  initState() {
    super.initState();
    addIdsFromFile().then((Null foo) => getData());
    updater = Timer.periodic(Duration(seconds: 30), (_) => updateData());
  }

  @override
  dispose() {
    updater.cancel();
    super.dispose();
  }

  Future<Null> addIdsFromFile() async {
    List<int> newIds = (await readIdsFromFile());
    if (newIds == [-1]) {
      return;
    } else {
      setState(() => channelIds.addAll(newIds));
    }
  }

  Future<Null> getData() async {
    setState(() => channelIds.removeWhere((id) => id == null || id < 1));
    for (int id in channelIds) {
      try {
        getChannel(id).then((Channel res) {
          setState(() {
            _channels.remove(res);
            _channels.add(res);
          });
        });
      } catch (e) {
        print("Couldn't find channel $id");
      }
    }
    writeIdsToFile(channelIds);
  }

  Future<Null> updateData() async {
    Stopwatch stopwatch = Stopwatch()..start();
    print('----------------------\nUpdating');
    for (Channel channel in _channels) {
      Channel updated = await channel.updatedChannel();
      setState(() {
        channel = updated;
      });
    }
    print('Done');
    print('Total: ${stopwatch.elapsed.inMilliseconds / 1000}');
  }

  Future<int> addChannel(int id) async {
    if (id == -1) return -1; // Input text page did not return new id.
    Channel newChannel = await getChannel(id);
    setState(() {
      _channels.add(newChannel);
      channelIds.add(id);
    });
    return 0; // Success!
  }
}
