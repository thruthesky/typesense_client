import 'package:flutter/material.dart';
import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/document.list.screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class DocumentEditScreen extends StatefulWidget {
  const DocumentEditScreen({Key? key}) : super(key: key);

  static const String routeName = '/documentEdit';

  @override
  State<DocumentEditScreen> createState() => _DocumentEditScreenState();
}

class _DocumentEditScreenState extends State<DocumentEditScreen> {
  String? get collectionName => Get.arguments?['collectionName'];
  String? get id => Get.arguments?['id'];
  List<dynamic> get fields => Get.arguments?['fields'] ?? [];

  bool get isUpdate => id != null;

  String documentSchema = '';

  @override
  void initState() {
    super.initState();
    {
      if (id != null) {
        App.to
            .getDocument(collectionName!, id!)
            .then((value) => setState(() => documentSchema = value.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document ${id == null ? 'Create' : 'Update'}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                collectionName == null
                    ? 'Create a new document to $collectionName collection'
                    : 'Updating document id $id from $collectionName collection',
              ),
              if (isUpdate) Text('$collectionName collection\n Document ID $id \n$documentSchema'),
              Text(getFieldsDescription()),
              TextField(
                controller: App.of.editDocumentController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                maxLines: 20,
                onChanged: (v) => setState(() {}),
              ),
              Row(
                children: [
                  TextButton(onPressed: () => Get.back(), child: Text('CANCEL')),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: App.of.editDocumentController.text == ''
                          ? null
                          : () async {
                              App.to.editDocument(name: collectionName!, id: id).catchError(
                                    (e) => Get.defaultDialog(
                                      title: 'ERROR',
                                      content: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  );
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

  getFieldsDescription() {
    if (fields.isEmpty) return '';
    String des = '';
    for (final field in fields) {
      des = "$des${field['name']}: ${field['type']}, ";
    }
    return des;
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
                'https://typesense.org/docs/0.23.1/api/documents.html#index-a-document',
              ),
            );
          },
          child: Text('* Open document - Create a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.23.1/api/documents.html#retrieve-a-document',
              ),
            );
          },
          child: Text('* Open document - Retrieve a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.23.1/api/documents.html#update-a-document',
              ),
            );
          },
          child: Text('* Open document - Update a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.23.1/api/documents.html#delete-documents',
              ),
            );
          },
          child: Text('* Open document - Delete a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.23.1/api/documents.html',
              ),
            );
          },
          child: Text('* Open document - More about Documents'),
        ),
      ],
    );
  }
}
