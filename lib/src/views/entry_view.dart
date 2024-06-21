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

class EntryView extends StatefulWidget {
  final void Function(int, String) assignTitleInScratch;

  const EntryView({super.key, required this.assignTitleInScratch});

  static const routeName = '/sample_item';

  @override
  EntryViewState createState() => EntryViewState();
}

class EntryViewState extends State<EntryView> {
  bool _isEditing = false;
  late TextEditingController _controller;
  late Entry entry;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argsStr = ModalRoute.of(context)!.settings.arguments as String;
    EntryViewArguments args = EntryViewArguments.fromJsonString(argsStr);
    entry = args.entry;
    _controller.text = entry.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing
            ? TextField(
                controller: _controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter new content",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ))
            : Text(_controller.text),
        actions: [
          IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
                widget.assignTitleInScratch(entry.id, _controller.text);
              })
        ],
      ),
      body: ListView(
        children: [
          Text("ID: ${entry.id.toString()}"),
          Text("Title: ${entry.title}"),
          Text("Content: ${entry.content}")
        ],
      ),
    );
  }
}
