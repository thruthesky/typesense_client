import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:typesense_client/app.controller.dart';
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
              children: [
                ConnectionInfo(),
                Divider(),
                for (final col in App.of.collections)
                  ExpansionTile(
                    title: Text(
                      col['name'],
                    ),
                    children: [
                      Text('Field Information'),
                      for (final field in col['fields'])
                        ListTile(
                          leading: Text('Name'),
                          title: Text("${field['name']}"),
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
