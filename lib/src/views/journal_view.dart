import 'package:flutter/material.dart';
import 'package:mind_flutter/src/db/entities.dart';

class JournalView extends StatefulWidget {
  final Future<List<Entry>> Function() loadEntries;
  final void Function(Entry) addEntry;
  final void Function(String) removeEntry;

  const JournalView(
      {super.key,
      required this.loadEntries,
      required this.addEntry,
      required this.removeEntry});

  static const routeName = '/journal';

  @override
  JournalViewState createState() => JournalViewState();
}

class JournalViewState extends State<JournalView> {
  @override
  Widget build(BuildContext context) {
    return const Text("This is the start of the log view");
  }
}
