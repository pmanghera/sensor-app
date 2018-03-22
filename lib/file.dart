/*
  Trying to add file support, so app will remember your channels
*/
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

Future<List<int>> readIdsFromFile() async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  print(dir);
  try {
    File file = new File('$dir/channelIds.txt');
    List<String> ids = (await file.readAsString()).split(' ');
    List<int> parsedIds = [];
    ids.removeWhere((id) => id == null);
    ids.forEach((str) => parsedIds.add(int.parse(str)));
    print('ids: $parsedIds');
    return parsedIds;
  } on FileSystemException {
    print('Where is it?');
    return [-1];
  }
}

Future<Null> writeIdsToFile(List<int> ids) async {
  String dir = (await getApplicationDocumentsDirectory()).path;
  print(dir);
  File file = new File('$dir/channelIds.txt');
  await file.writeAsString(ids.join(' '));
  print(file.readAsStringSync());
}

main() {
  File file = new File('iMadeThis.txt');
  file.writeAsStringSync('Hello, world!');
}
