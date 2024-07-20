import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/entities.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

Logger logger = Logger(printer: PrettyPrinter());

class EntryViewArguments {
  final Entry entry;
  final Function(String) assignTitle;
  final Function(String) assignContent;
  EntryViewArguments(this.entry, this.assignTitle, this.assignContent);
}

class EntryView extends StatefulWidget {
  // final void Function(String, String) assignTitle;
  const EntryView({super.key});
  static const routeName = '/sample_item';

  @override
  EntryViewState createState() => EntryViewState();
}

class EntryViewState extends State<EntryView> {
  // late TextEditingController _titleController;
  // late TextEditingController _contentController;
  late Entry entry;
  late Function() refreshParent;

  late Function(String) assignTitle;
  late Function(String) assignContent;

  @override
  void initState() {
    super.initState();
    // _titleController = TextEditingController();
    // _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final EntryViewArguments args =
        ModalRoute.of(context)!.settings.arguments as EntryViewArguments;
    entry = args.entry;
    assignTitle = args.assignTitle;
    assignContent = args.assignContent;
    // refreshParent = args.refreshParent;
    // _titleController.text = entry.title;
    // _contentController.text = entry.content;
  }

  @override
  void dispose() {
    // _titleController.dispose();
    // _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EditText(
            text: entry.title,
            onChange: (String newTitle) {
              setState(() {
                entry.title = newTitle;
              });
              assignTitle(newTitle);
            }),
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
            child: EditText(
                text: entry.content,
                onChange: (String newContent) {
                  setState(() {
                    entry.content = newContent;
                  });
                  assignContent(newContent);
                }),
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
