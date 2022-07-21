import 'package:flutter/material.dart';
import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/collection.list.screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class CollectionEditScreen extends StatefulWidget {
  const CollectionEditScreen({Key? key}) : super(key: key);

  static const String routeName = '/collectionEdit';

  @override
  State<CollectionEditScreen> createState() => _CollectionEditScreenState();
}

class _CollectionEditScreenState extends State<CollectionEditScreen> {
  String? get name => Get.parameters['name'];

  bool get isUpdate => name != null;

  String collectionSchema = '';

  @override
  void initState() {
    super.initState();
    {
      if (name != null) {
        App.to.getCollection(name!).then(
            (value) => setState(() => collectionSchema = value.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection ${name == null ? 'Create' : 'Update'}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name == null
                    ? 'Create a collection'
                    : 'Updating $name collection',
              ),
              if (isUpdate)
                Text(
                  '* You can only update fields. You cannot rename the collection',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (isUpdate)
                Text('Schema of $name collection\n$collectionSchema'),
              TextField(
                controller: App.of.editSchema,
                decoration: InputDecoration(border: OutlineInputBorder()),
                maxLines: 20,
                onChanged: (v) => setState(() {}),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () =>
                          Get.toNamed(CollectionListScreen.routeName),
                      child: Text('CANCEL')),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: App.of.editSchema.text == ''
                          ? null
                          : () async {
                              App.to.editCollection(name: name).catchError(
                                  (e) => Get.defaultDialog(
                                      title: 'ERROR',
                                      content: SingleChildScrollView(
                                          child: Text(e.toString()))));
                            },
                      child: Text('SUBMIT'),
                    ),
                  ),
                ],
              ),
              Align(alignment: Alignment.centerRight, child: HelpLinks()),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpLinks extends StatelessWidget {
  const HelpLinks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/guide/building-a-search-application.html#creating-a-books-collection',
              ),
            );
          },
          child: Text('* Open document - Create a Collection'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.23.1/api/collections.html',
              ),
            );
          },
          child: Text('* Open document - More about Collection'),
        ),
      ],
    );
  }
}
