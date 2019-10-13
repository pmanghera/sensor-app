/*
  Trying to add file support, so app will remember your channels
*/
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<int>> readIdsFromFile() async {
  final sp = await SharedPreferences.getInstance();
  List<int> ids = [];
  json.decode(sp.getString('channelIds')).forEach((id) => ids.add(id));
  print(ids);

  return ids;
}

Future<Null> writeIdsToFile(Iterable<int> ids) async {
  final sp = await SharedPreferences.getInstance();
  String encodedIds = json.encode(ids.toList());
  print(encodedIds);
  sp.setString('channelIds', encodedIds);
}
