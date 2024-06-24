import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/ui/edit_title.dart';

Logger logger = Logger(printer: PrettyPrinter());

class EntryViewArguments {
  final Entry entry;
  final Function() refreshParent;
  EntryViewArguments(this.entry, this.refreshParent);
}

class EntryView extends StatefulWidget {
  final void Function(String, String) assignTitleInScratch;
  const EntryView({super.key, required this.assignTitleInScratch});
  static const routeName = '/sample_item';

  @override
  EntryViewState createState() => EntryViewState();
}

class EntryViewState extends State<EntryView> {
  // late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Entry entry;
  late Function() refreshParent;

  @override
  void initState() {
    super.initState();
    // _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final EntryViewArguments args =
        ModalRoute.of(context)!.settings.arguments as EntryViewArguments;
    entry = args.entry;
    refreshParent = args.refreshParent;
    // _titleController.text = entry.title;
    _contentController.text = entry.content;
  }

  @override
  void dispose() {
    // _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EditText(onChange: (String newTitle) {
          setState(() {
            entry.title = newTitle;
          });
          widget.assignTitleInScratch(entry.id, newTitle);
          refreshParent();
        }),
        // title: _isEditing
        //     ? TextField(
        //         controller: _titleController,
        //         autofocus: true,
        //         style: const TextStyle(color: Colors.white),
        //         decoration: InputDecoration(
        //           hintText: entry.title,
        //           border: InputBorder.none,
        //           hintStyle: const TextStyle(color: Colors.white70),
        //         ))
        //     : Text(_titleController.text != ""
        //         ? _titleController.text
        //         : "[No title]"),
        // actions: [
        //   IconButton(
        //       icon: Icon(_isEditing ? Icons.check : Icons.edit),
        //       onPressed: () {
        //         setState(() {
        //           entry.title = _titleController.text;
        //           entry.content = _contentController.text;
        //           _isEditing = !_isEditing;
        //         });
        //         widget.assignTitleInScratch(entry.id, _titleController.text);
        //         refreshParent();
        //       })
        // ],
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
                  const Text("Content:", style: TextStyle(fontSize: 18)),
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {})
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
