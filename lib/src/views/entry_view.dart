import 'dart:convert';

import 'package:flutter/material.dart';

class EntryViewArguments {
  final String title;

  EntryViewArguments(this.title);

  Map<String, dynamic> toJson() => {'title': title};

  String toJsonString() => json.encode(toJson());

  factory EntryViewArguments.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return EntryViewArguments(jsonMap['title'] as String);
  }
}

class EntryView extends StatelessWidget {
  const EntryView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    String argsStr = ModalRoute.of(context)!.settings.arguments as String;
    EntryViewArguments args = EntryViewArguments.fromJsonString(argsStr);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.title),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
