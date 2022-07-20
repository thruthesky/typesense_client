import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Node;
import 'package:hive/hive.dart';

class App extends GetxController {
  static App get to => Get.find<App>();
  static App get of => Get.find<App>();
  final Dio dio = Dio();

  ///
  final url = TextEditingController(text: '');
  final apiKey = TextEditingController(text: '');

  List<dynamic> collections = [];

  @override
  void onInit() {
    super.onInit();
    url.text = get('url') ?? '';
    apiKey.text = get('apiKey') ?? '';
  }

  void loadCollections() async {
    final res = await dio.get(
      '${url.text}/collections',
      options: Options(
        headers: {
          "X-TYPESENSE-API-KEY": apiKey.text,
        },
      ),
    );
    collections = res.data;
    update();
    debugPrint(res.toString());
  }

  updateConnectionInfomation() {
    put('url', url.text);
    put('apiKey', apiKey.text);
  }

  put(String key, dynamic value) {
    final box = Hive.box('settings');
    box.put('url', url.text);
    box.put('apiKey', apiKey.text);
  }

  get(String key) {
    final box = Hive.box('settings');
    return box.get(key);
  }
}
