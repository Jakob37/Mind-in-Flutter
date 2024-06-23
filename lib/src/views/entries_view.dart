import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:mind_flutter/src/util.dart';
import 'package:mind_flutter/src/views/entry_view.dart';

import '../database.dart';
import '../ui/input_modal.dart';

Logger logger = Logger(printer: PrettyPrinter());

class EntriesView extends StatefulWidget {
  final List<Entry> Function() loadEntries;
  final void Function(List<Entry>) assignEntries;

  const EntriesView(
      {super.key, required this.loadEntries, required this.assignEntries});

  // Used in app.dart
  static const routeName = '/';

  @override
  EntriesViewState createState() => EntriesViewState();
}

class EntriesViewState extends State<EntriesView> {
  List<Entry> entries = [];

  @override
  void didChangeDependencies() {
    List<Entry> myEntries = widget.loadEntries();
    setState(() {
      entries = myEntries;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget getList() {
      return ReorderableListView(
        onReorder: _onReorder,
        children: [
          ...entries.map((item) => _buildItem(context, item)),
        ],
      );
    }

    return Scaffold(
        body: SafeArea(child: Column(children: [Expanded(child: getList())])),
        bottomNavigationBar: ElevatedButton(
            onPressed: () => _showModal(context),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
            ),
            child: const Text('Add entry', style: TextStyle(fontSize: 18))));
  }

  Widget _buildItem(BuildContext context, Entry entry) {
    var args = EntryViewArguments(entry, () {}).toJsonString();

    // var args = {
    //   'entry': entry,
    //   'updateEntries': updateEntries
    // }

    return entryCard(entry, () {
      Navigator.restorablePushNamed(context, EntryView.routeName,
          arguments: args);
    }, () {
      int index = entries.indexOf(entry);
      _removeItem(index);
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Entry item = entries.removeAt(oldIndex);
      entries.insert(newIndex, item);
      widget.assignEntries(entries);
    });
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
    String id = getEntryId();
    Entry entry = Entry(id, DateTime.now(), DateTime.now(), title, "");
    entries.add(entry);
    widget.assignEntries(entries);
    setState(() {});
  }

  void _removeItem(int index) async {
    entries.removeAt(index);
    setState(() {});
    widget.assignEntries(entries);
  }
}
