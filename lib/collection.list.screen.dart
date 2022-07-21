import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/collection.edit.screen.dart';
import 'package:typesense_client/document.list.screen.dart';
import 'package:typesense_client/widgets/connection_info.dart';

class CollectionListScreen extends StatelessWidget {
  CollectionListScreen({Key? key}) : super(key: key) {
    App.to.loadCollections();
  }

  static const routeName = '/collection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collections',
        ),
      ),
      body: GetBuilder<App>(builder: (_) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConnectionInfo(),
                Divider(),
                Row(
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => Get.toNamed(CollectionEditScreen.routeName),
                      child: Text('Create Collection'),
                    ),
                  ],
                ),
                for (final col in App.of.collections)
                  ExpansionTile(
                    key: ValueKey(col['name']),
                    title: Text(
                      col['name'],
                    ),
                    children: [
                      Row(
                        children: [
                          Text('Field Information'),
                          Spacer(),
                          TextButton(
                            onPressed: () => Get.toNamed(
                              DocumentListScreen.routeName,
                              arguments: {'name': col['name']},
                            ),
                            child: Text('LIST DOCUMENTS'),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(
                              CollectionEditScreen.routeName,
                              arguments: {'name': col['name']},
                            ),
                            child: Text('EDIT'),
                          ),
                          TextButton(
                            onPressed: () async {
                              bool re = await showDialog(
                                context: context,
                                builder: (__) => AlertDialog(
                                  title: Text('Delete ${col['name']} Collection'),
                                  content: Text('Do you want to delete ${col['name']} collection?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: Text('NO'),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: Text('YES'),
                                    ),
                                  ],
                                ),
                              );
                              if (re == false) return;
                              App.to.deleteCollection(col['name']);
                            },
                            child: Text('DELETE'),
                          ),
                        ],
                      ),
                      for (final field in col['fields'])
                        ListTile(
                          title: Text("${field['name']}"),
                          subtitle: Text(
                            subtitleFieldOptions(field),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String subtitleFieldOptions(dynamic field) {
    return "index: ${field['index']}, type: ${field['type']}, optional: ${field['optional']}, sort: ${field['sort']}, facet: ${field['facet']}, infix: ${field['infix']}, locale: ${field['locale'] ?? ''}";
  }
}
