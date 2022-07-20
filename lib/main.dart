import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/collection.edit.screen.dart';
import 'package:typesense_client/collection.screen.dart';
import 'package:typesense_client/entry.screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _MyAppState() {
    Get.put(App());
    App.of.apiKey.text = '12345a';
    App.of.url.text = 'https://typesense.philgo.com';
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        EntryScreen.routeName: (_) => EntryScreen(),
        CollectionScreen.routeName: (_) => CollectionScreen(),
        CollectionEditScreen.routeName: (_) => CollectionEditScreen(),
      },
    );
  }
}
