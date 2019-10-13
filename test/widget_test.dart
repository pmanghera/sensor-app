// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'dart:io';

// import 'package:myapp/main.dart';

void main() {
  setUpAll(() async {
    // final directory = await Directory.systemTemp.createTemp();

    // const MethodChannel('plugins.flutter.io/path_provider')
    //     .setMockMethodCallHandler((MethodCall methodCall) async {
    //   if (methodCall.method == 'getApplicationDocumentsDirectory') {
    //     return directory.path;
    //   }
    //   return null;
    // });
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getString') {
        return '[9]';
      }
      return null;
    });
  });
}
