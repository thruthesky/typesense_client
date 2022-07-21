import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/collection.edit.screen.dart';
import 'package:typesense_client/collection.list.screen.dart';
import 'package:typesense_client/document.edit.dart';
import 'package:typesense_client/document.list.screen.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: EntryScreen.routeName, page: () => EntryScreen()),
        GetPage(
            name: CollectionListScreen.routeName,
            page: () => CollectionListScreen()),
        GetPage(
            name: CollectionEditScreen.routeName,
            page: () => CollectionEditScreen()),
        GetPage(
            name: DocumentListScreen.routeName,
            page: () => DocumentListScreen()),
        GetPage(
            name: DocumentEditScreen.routeName,
            page: () => DocumentEditScreen()),
      ],
    );
  }
}
