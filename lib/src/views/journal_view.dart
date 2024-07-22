import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/entities.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

Logger logger = Logger(printer: PrettyPrinter());

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
  List<Entry> entries = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    List<Entry> journalEntries = await widget.loadEntries();
    if (mounted) {
      setState(() {
        entries = journalEntries;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getList() {
      return ReorderableListView(
        onReorder: _onReorder,
        children: [
          ...entries.map((entry) => _buildEntryCard(context, entry)),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(child: entriesList(entries)),
      // body: SafeArea(child: Column(children: [Expanded(child: getList())])),
      bottomNavigationBar:
          sharedBottomButton("Add journal", () => logger.w("Pressed")),
    );
  }

  void _onReorder(int first, int second) {}

  Widget _buildEntryCard(BuildContext context, entry) {
    return const Text("Empty widget");
  }
}

Widget entriesList(List<Entry> entries) {
  return Column(children: [
    Expanded(
        child: ListView(
            children: entries.map((entry) => getEntryCard(entry)).toList()))
  ]);
}

Widget getEntryCard(Entry entry) {
  return entryCard(entry, () {}, () {}, () {});
}


// class EntriesList extends StatefulWidget {
//   const EntriesList({super.key});

//   @override
//   EntriesListState createState() => EntriesListState();
// }

// class EntriesListState extends State<EntriesList> {

// }
