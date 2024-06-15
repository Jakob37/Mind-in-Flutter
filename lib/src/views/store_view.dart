import 'dart:convert';

import 'package:flutter/material.dart';

class StoreViewArguments {
  final String title;

  StoreViewArguments(this.title);

  Map<String, dynamic> toJson() => {'title': title};

  String toJsonString() => json.encode(toJson());

  factory StoreViewArguments.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return StoreViewArguments(jsonMap['title'] as String);
  }
}

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  static const routeName = '/store_view';

  @override
  Widget build(BuildContext context) {
    String argsStr = ModalRoute.of(context)!.settings.arguments as String;
    StoreViewArguments args = StoreViewArguments.fromJsonString(argsStr);

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
        ),
        body: const Center(child: Text('List the entries here')));
  }
}
