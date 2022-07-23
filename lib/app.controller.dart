import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Node, Response;
import 'package:hive/hive.dart';
import 'package:typesense_client/collection.list.screen.dart';
import 'package:typesense_client/document.list.screen.dart';

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
    try {
      
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
    } on DioError catch (e) {
      if ( e.message.contains('XMLHttpRequest error')) {
      Get.defaultDialog(title: 'Connection Error', content: Text( "Please check the Typesense Server URL and API Key are properly set. Or the server is alive."));
      } else {
        rethrow;
      }
    } catch (e) {
      Get.defaultDialog(title: e.toString());
    }
  }

  Future<Map<String, dynamic>> searchDocuments({
    required String collectionName,
    required String parameters,
    required int page,
    required int perPage,
  }) async {
    final requestUrl =
        '${url.text}/collections/$collectionName/documents/search?$parameters&page=$page&per_page=$perPage';
    debugPrint(requestUrl);
    final res = await dio.get(
      requestUrl,
      options: Options(
        headers: {
          "X-TYPESENSE-API-KEY": apiKey.text,
        },
        validateStatus: (status) {
          return (status ?? 0) < 500;
        },
      ),
    );
    debugPrint(res.data.toString());
    if (res.statusCode! > 299) {
      throw res.data.toString();
    }
    return res.data;
  }

  Future getCollection(String name) async {
    final res = await dio.get(
      '${url.text}/collections/$name',
      options: Options(
        headers: {
          "X-TYPESENSE-API-KEY": apiKey.text,
        },
      ),
    );
    debugPrint(res.data.toString());
    return res.data;
  }

  Future getDocument(String collectionName, String id) async {
    final res = await dio.get(
      '${url.text}/collections/$collectionName/documents/$id',
      options: Options(
        headers: {
          "X-TYPESENSE-API-KEY": apiKey.text,
        },
      ),
    );
    debugPrint(res.data.toString());
    return res.data;
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

  Future editCollection({String? name}) async {
    try {
      json.decode(editSchema.text) as Map<String, dynamic>;
    } on FormatException catch (e) {
      debugPrint('The provided string is not valid JSON, $e');
      throw 'Please, input correct JSON syntax.';
    }

    Response res;

    if (name == null) {
      res = await dio.post(
        '${url.text}/collections',
        data: editSchema.text,
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
          validateStatus: (status) {
            return (status ?? 0) < 500;
          },
        ),
      );
    } else {
      res = await dio.patch(
        '${url.text}/collections/$name',
        data: editSchema.text,
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
          validateStatus: (status) {
            return (status ?? 0) < 500;
          },
        ),
      );
    }

    debugPrint('result, ${res.statusCode}');
    debugPrint(res.toString());
    if (res.statusCode! > 299) {
      throw res.data.toString();
    }

    editSchema.text = '';
    Get.toNamed(CollectionListScreen.routeName);
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

  jsonDataCheck(String text) {
    try {
      json.decode(text) as Map<String, dynamic>;
    } on FormatException catch (e) {
      debugPrint('The provided string is not valid JSON, $e');
      throw 'Please, input correct JSON syntax.';
    }
  }

  final editDocumentController = TextEditingController(text: '');

  Future editDocument({required String name, String? id}) async {
    jsonDataCheck(editDocumentController.text);

    Response res;

    if (id == null) {
      res = await dio.post(
        '${url.text}/collections/$name/documents',
        data: editDocumentController.text,
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
          validateStatus: (status) {
            return (status ?? 0) < 500;
          },
        ),
      );
    } else {
      res = await dio.patch(
        '${url.text}/collections/$name/documents/$id',
        data: editDocumentController.text,
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
          validateStatus: (status) {
            return (status ?? 0) < 500;
          },
        ),
      );
    }

    debugPrint('result, ${res.statusCode}');
    debugPrint(res.toString());
    if (res.statusCode == 400) {
      throw res.data.toString();
    }

    editDocumentController.text = '';
    // Get.toNamed(
    //   DocumentListScreen.routeName,
    //   arguments: {'name': name},
    // );
    // Get.offNamed(
    //   DocumentListScreen.routeName,
    //   arguments: {'name': name},
    // );
    Get.back(result: true);
  }

  ///
  /// DELETE COLLECTION
  ///
  deleteDocument(String name, String id) async {
    try {
      final res = await dio.delete(
        '${url.text}/collections/$name/documents/$id',
        options: Options(
          headers: {
            "X-TYPESENSE-API-KEY": apiKey.text,
          },
        ),
      );
      debugPrint('res; $res');
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
