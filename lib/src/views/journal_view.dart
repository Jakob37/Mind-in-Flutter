import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/dbutil.dart';
import 'package:mind_flutter/src/db/entities.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:mind_flutter/src/views/entry_view.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

Logger logger = Logger(printer: PrettyPrinter());

class JournalView extends StatefulWidget {
  final Future<List<Entry>> Function() loadEntriesFromDb;
  final void Function(Entry) addEntryToDb;
  final void Function(String) removeEntryFromDb;

  const JournalView(
      {super.key,
      required this.loadEntriesFromDb,
      required this.addEntryToDb,
      required this.removeEntryFromDb});

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
    List<Entry> journalEntries = await widget.loadEntriesFromDb();
    if (mounted) {
      setState(() {
        entries = journalEntries;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void refreshState() {
      setState(() {});
    }

    void removeEntry(Entry entry) {
      logger.i("removeEntry triggered");
      int index = entries.indexOf(entry);
      entries.removeAt(index);
      setState(() {});
      widget.removeEntryFromDb(entry.id);
      // _removeEntry(index);
    }

    return Scaffold(
      body: SafeArea(
          child: entriesList(context, entries, refreshState, removeEntry)),
      // body: SafeArea(child: Column(children: [Expanded(child: getList())])),
      bottomNavigationBar:
          sharedBottomButton("Add entry", () => _showModal(context)),
    );
  }

  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => InputModal(
        onSubmitted: (value) {
          setState(() {
            _addNewItem(value);
          });
        },
      ),
    );
  }

  void _addNewItem(String title) async {
    Entry entry = createEmptyEntry(title);
    entries.add(entry);
    widget.addEntryToDb(entry);
    // widget.assignEntries(entries);
    setState(() {});
  }
}

Widget entriesList(BuildContext context, List<Entry> entries,
    Function refreshState, Function(Entry) removeEntry) {
  entries.sort((a, b) => -a.created.compareTo(b.created));
  return Column(children: [
    Expanded(
        child: ListView(
            children: entries
                .map((entry) =>
                    getEntryCard(context, entry, refreshState, removeEntry))
                .toList()))
  ]);
}

Widget getEntryCard(BuildContext context, Entry entry, Function refreshState,
    Function(Entry) removeEntry) {
  // FIXME: Should the child page only take 'refreshState'?
  void assignPlaceholder(String placeholder) {
    refreshState();
  }

  EntryViewArguments args =
      EntryViewArguments(entry, assignPlaceholder, assignPlaceholder);

  // onDismissLeft() {
  //   int index = entries.indexOf(entry);
  //   _removeEntry(index);
  // }

  return entryCard(entry, () {
    Navigator.pushNamed(context, EntryView.routeName, arguments: args);
    // logger.i("Tapping entry ${entry.title}");
  }, () {
    removeEntry(entry);
  }, () {
    logger.i("Dismissing right");
  }, showDate: true);
}
