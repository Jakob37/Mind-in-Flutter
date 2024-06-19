import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/database.dart';

Logger logger = Logger(printer: PrettyPrinter());

class EntryViewArguments {
  final Entry entry;

  EntryViewArguments(this.entry);

  Map<String, dynamic> toJson() => {'entry': entry.toJson()};

  String toJsonString() => json.encode(toJson());

  factory EntryViewArguments.fromJsonString(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    Entry entry = Entry.fromJson(jsonMap['entry']);
    return EntryViewArguments(entry);
  }
}

class EntryView extends StatelessWidget {
  const EntryView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    String argsStr = ModalRoute.of(context)!.settings.arguments as String;
    EntryViewArguments args = EntryViewArguments.fromJsonString(argsStr);
    Entry entry = args.entry;

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.content),
      ),
      body: Center(
        child: Text(entry.content),
      ),
    );
  }
}
