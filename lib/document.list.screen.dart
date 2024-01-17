import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:typesense_client/app.controller.dart';
import 'package:typesense_client/document.edit.dart';

class DocumentListScreen extends StatefulWidget {
  const DocumentListScreen({Key? key}) : super(key: key);

  static const String routeName = '/documentList';

  @override
  State<DocumentListScreen> createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  String get name => Get.arguments?['name']!;
  List<dynamic> get fields => Get.arguments?['fields'] ?? [];

  static const _pageSize = 50;

  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 0);

  final query = TextEditingController(text: "q=*");

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      debugPrint('pageKey; $pageKey');
      final res = await App.to.searchDocuments(
        collectionName: name,
        parameters: query.text,
        page: (pageKey ~/ _pageSize) + 1,
        perPage: _pageSize,
      );
      final newItems = res['hits'];
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey.toInt());
      }
    } catch (error) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('$error'),
              ));
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
              onPressed: () async {
                final re = await Get.toNamed(
                  DocumentEditScreen.routeName,
                  arguments: {'collectionName': name, "fields": fields},
                );

                if (re == true) {
                  _pagingController.refresh();
                }
              },
              icon: Icon(Icons.create))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: query,
                  decoration: InputDecoration(label: Text('Query parameters')),
                  onSubmitted: (q) {
                    _pagingController.refresh();
                  },
                ),
                SizedBox(
                  height: 48,
                  child: Text(
                    getFieldsDescription(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: PagedListView<int, dynamic>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          itemBuilder: (context, item, index) => ListTile(
            title: Text("($index) ${item['document']['id']}"),
            subtitle: Column(
              children: [
                Text("$item"),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                        onPressed: () async {
                          final re = await Get.toNamed(
                            DocumentEditScreen.routeName,
                            arguments: {
                              'collectionName': name,
                              'id': item['document']['id'],
                              "fields": fields
                            },
                          );
                          if (re == true) _pagingController.refresh();
                        },
                        child: Text('EDIT')),
                    TextButton(
                      onPressed: () async {
                        bool re = await showDialog(
                          context: context,
                          builder: (__) => AlertDialog(
                            title: Text('Delete ${item['document']['id']} document'),
                            content:
                                Text('Do you want to delete ${item['document']['id']} document?'),
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
                        await App.to.deleteDocument(name, item['document']['id']);
                        setState(() {
                          _pagingController.itemList?.removeAt(index);
                        });
                      },
                      child: Text('DELETE'),
                    ),
                  ],
                ),
              ],
            ),
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
