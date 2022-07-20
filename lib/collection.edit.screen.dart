import 'package:flutter/material.dart';
import 'package:typesense_client/app.controller.dart';
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
                    Uri.parse('https://typesense.org/docs/0.23.1/api/collections.html'),
                  );
                },
                child: Text('* Open document - More about Collection'),
              ),
              TextField(
                controller: App.of.editSchema,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: App.to.editCollection,
                  child: Text('SUBMIT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
