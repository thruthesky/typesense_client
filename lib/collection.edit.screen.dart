import 'package:flutter/material.dart';
import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/models/collections.model.dart';
import 'package:url_launcher/url_launcher.dart';

class CollectionEditScreen extends StatelessWidget {
  const CollectionEditScreen({Key? key}) : super(key: key);

  static const String routeName = '/collectionEdit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection Edit'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input a schema to create (or update) a collection.',
              ),
              TextButton(
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                        'https://typesense.org/docs/guide/building-a-search-application.html#creating-a-books-collection'),
                  );
                },
                child: Text('* Open document - Create a Collection'),
              ),
              TextButton(
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                        'https://typesense.org/docs/0.23.1/api/collections.html'),
                  );
                },
                child: Text('* Open document - More about Collection'),
              ),
              CollectionForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class CollectionForm extends StatefulWidget {
  const CollectionForm({
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionForm> createState() => _CollectionFormState();
}

class _CollectionFormState extends State<CollectionForm> {
  TextEditingController collectionName = TextEditingController(text: '');
  CollectionModel? col;

  @override
  void initState() {
    super.initState();
    loadSchema();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: collectionName,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ElevatedButton(
            onPressed: () => loadSchema(),
            child: Text('SUBMIT'),
          ),
        ),
        if (col != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Text("Collection Name:"),
                title: Text(col!.name),
              ),
              Divider(),
              Text('Collection Fields'),
              for (final field in col!.fields)
                ExpansionTile(
                  title: Text("${field['name']}"),
                  children: [
                    ListTile(
                      leading: Text('index:'),
                      title: Text("${field['index']}"),
                    ),
                    ListTile(
                      leading: Text('type:'),
                      title: Text("${field['type']}"),
                    ),
                    ListTile(
                      leading: Text('optional:'),
                      title: Text("${field['optional']}"),
                    ),
                    ListTile(
                      leading: Text('sort:'),
                      title: Text("${field['sort']}"),
                    ),
                    ListTile(
                      leading: Text('facet:'),
                      title: Text("${field['facet']}"),
                    ),
                    ListTile(
                      leading: Text('infix:'),
                      title: Text("${field['infix']}"),
                    ),
                    ListTile(
                      leading: Text('locale:'),
                      title: Text("${field['locale']}"),
                    )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () => saveSchema(),
                  child: Text('Save'),
                ),
              ),
            ],
          )
      ],
    );
  }

  loadSchema() async {
    if (collectionName.text.isEmpty) return;
    final res = await App.of.getCollection(collectionName.text);
    if (res != null) {
      debugPrint('update');
      col = CollectionModel.fromJson(res);
    } else {
      debugPrint('create');
      col = CollectionModel.fromJson({"name": collectionName.text});
    }
    setState(() {});
  }

  saveSchema() {
    print(col);
  }
}
