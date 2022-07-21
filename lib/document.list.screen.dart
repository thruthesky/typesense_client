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
  String get name => Get.parameters['name']!;

  static const _pageSize = 10;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 0);

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
        parameters: 'q=*',
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
              onPressed: () {
                Get.toNamed(
                  DocumentEditScreen.routeName,
                  parameters: {'name': name},
                );
              },
              icon: Icon(Icons.create))
        ],
        bottom: AppBarBotom(
          height: 60,
          child: Container(
            color: Colors.white,
            child: TextField(
              controller: query,
              decoration: InputDecoration(label: Text('Query parameters')),
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
                        onPressed: () {
                          Get.toNamed(
                            DocumentEditScreen.routeName,
                            parameters: {
                              'name': name,
                              'id': item['document']['id']
                            },
                          );
                        },
                        child: Text('EDIT')),
                    TextButton(
                        onPressed: () async {
                          bool re = await showDialog(
                            context: context,
                            builder: (__) => AlertDialog(
                              title: Text(
                                  'Delete ${item['document']['id']} document'),
                              content: Text(
                                  'Do you want to delete ${item['document']['id']} document?'),
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
                          App.to.deleteDocument(name, item['document']['id']);
                        },
                        child: Text('DELETE')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarBotom extends StatelessWidget with PreferredSizeWidget {
  AppBarBotom({
    required this.child,
    required this.height,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}