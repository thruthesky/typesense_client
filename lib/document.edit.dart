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
  String? get name => Get.parameters['name'];
  String? get id => Get.parameters['id'];

  bool get isUpdate => id != null;

  String documentSchema = '';

  @override
  void initState() {
    super.initState();
    {
      if (id != null) {
        App.to
            .getDocument(name!, id!)
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
                name == null
                    ? 'Create a new document to $name collection'
                    : 'Updating document id $id from $name collection',
              ),
              if (isUpdate)
                Text(
                    'Document of $name collection\n with ID $id \n$documentSchema'),
              TextField(
                controller: App.of.editDocumentController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                maxLines: 20,
                onChanged: (v) => setState(() {}),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () => Get.toNamed(
                            DocumentListScreen.routeName,
                            parameters: {'name': name!},
                          ),
                      child: Text('CANCEL')),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: App.of.editDocumentController.text == ''
                          ? null
                          : () async {
                              App.to
                                  .editDocument(name: name!, id: id)
                                  .catchError(
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
                'https://typesense.org/docs/0.19.0/api/documents.html#index-a-document',
              ),
            );
          },
          child: Text('* Open document - Create a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.19.0/api/documents.html#retrieve-a-document',
              ),
            );
          },
          child: Text('* Open document - Retrieve a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.19.0/api/documents.html#update-a-document',
              ),
            );
          },
          child: Text('* Open document - Update a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.19.0/api/documents.html#delete-documents',
              ),
            );
          },
          child: Text('* Open document - Delete a Document'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://typesense.org/docs/0.19.0/api/documents.html',
              ),
            );
          },
          child: Text('* Open document - More about Documents'),
        ),
      ],
    );
  }
}
