import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

Future<List<int>> readIdsFromFile() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  try {
    File file = new File('$dir/channelIds.txt');
    List<String> ids = (await file.readAsString()).split(' ');
    return ids.forEach((str) => int.parse(str));
  } on FileSystemException {
    return [];
  }
}

void writeIdsToFile(List<int> ids) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = new File('$dir/channelIds.txt');
  file.writeAsStringSync(ids.join(' '));
}
