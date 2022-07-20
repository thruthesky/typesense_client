import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Node;
import 'package:hive/hive.dart';
import 'package:typesense_client/collection.screen.dart';

class App extends GetxController {
  static App get to => Get.find<App>();
  static App get of => Get.find<App>();
  final Dio dio = Dio();

  /// For Typesense connection informaton
  final url = TextEditingController(text: '');
  final apiKey = TextEditingController(text: '');

  List<dynamic> collections = [];

  @override
  void onInit() {
    super.onInit();
    url.text = get('url') ?? '';
    apiKey.text = get('apiKey') ?? '';
  }

  loadCollections() async {
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

  getCollection(String name) async {
    try {
      final res = await dio.get(
        '${url.text}/collections/$name',
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
        ),
      );
      debugPrint(res.toString());
      return res.data;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
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

  ///
  /// EDIT COLLECTION
  ///

  final editSchema = TextEditingController(text: '');
  editCollection() async {
    try {
      final res = await dio.post(
        '${url.text}/collections',
        data: editSchema.text,
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
        ),
      );
      debugPrint('res; $res');
      Get.toNamed(CollectionScreen.routeName);
    } catch (e) {
      debugPrint(e.toString());

      return null;
    }
  }

  ///
  /// DELETE COLLECTION
  ///
  deleteCollection(String name) async {
    try {
      final res = await dio.delete(
        '${url.text}/collections/$name',
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
        ),
      );
      debugPrint('res; $res');

      await loadCollections();
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
