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
  final void Function(String, String) assignTitleInScratch;
  const EntryView({super.key, required this.assignTitleInScratch});
  static const routeName = '/sample_item';

  @override
  EntryViewState createState() => EntryViewState();
}

class EntryViewState extends State<EntryView> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Entry entry;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final argsStr = ModalRoute.of(context)!.settings.arguments as String;
    EntryViewArguments args = EntryViewArguments.fromJsonString(argsStr);
    entry = args.entry;
    _titleController.text = entry.title;
    _contentController.text = entry.content;
  }

  @override
  Widget build(BuildContext context) {
    // List<String> details = [
    //   "ID: ${entry.id.toString()}",
    //   "Title: ${entry.title}",
    //   "Content: ${entry.content}"
    // ];

    return Scaffold(
      appBar: AppBar(
        title: _isEditing
            ? TextField(
                controller: _titleController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: entry.title,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Colors.white70),
                ))
            : Text(_titleController.text != ""
                ? _titleController.text
                : "[No title]"),
        actions: [
          IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
                widget.assignTitleInScratch(entry.id, _titleController.text);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("ID: ${entry.id}",
                  style: const TextStyle(fontSize: 14))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Content:", style: const TextStyle(fontSize: 18)),
                  IconButton(icon: Icon(Icons.edit), onPressed: () {})
                ]),
          ),
          // Text("Content:", style: const TextStyle(fontSize: 18))),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(entry.content, style: const TextStyle(fontSize: 18)))
        ]),
      ),
    );
  }
}
