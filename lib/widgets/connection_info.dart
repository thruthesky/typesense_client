import 'package:flutter/material.dart';
import 'package:typesense_client/app.controller.dart';

class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Server URL: ${App.to.get('url')}"),
        Text("Api Key: ${App.to.get('apiKey')}"),
      ],
    );
  }
}
