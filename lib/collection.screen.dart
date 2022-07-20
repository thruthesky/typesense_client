import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/collection.edit.screen.dart';
import 'package:typesense_client/widgets/connection_info.dart';

class CollectionScreen extends StatelessWidget {
  CollectionScreen({Key? key}) : super(key: key) {
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
      body: GetBuilder<App>(builder: (context) {
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
                    title: Text(
                      col['name'],
                    ),
                    children: [
                      Text('Field Information'),
                      for (final field in col['fields'])
                        ListTile(
                          title: Text("${field['name']}"),
                          subtitle: Text("${field['type']}, optional: ${field['optiona'] ?? ''}"),
                        ),
                      Text('@TODO Show list of document in new screen'),
                      Text('@TODO Add a document'),
                      Text('@TODO Update a document'),
                      Text('@TODO Delete a document'),
                    ],
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
