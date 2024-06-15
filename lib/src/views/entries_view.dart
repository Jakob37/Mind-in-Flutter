import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/storage_helper.dart';

import '../database.dart';
import '../ui/input_modal.dart';
import 'entry_view.dart';

import 'dart:convert';

Logger logger = Logger(printer: PrettyPrinter());

// const String SCRATCH_FILENAME = "data.txt";
// const String STORE_FILENAME = "store.txt";
const String DB_FILENAME = "db.txt";

Widget appTabsView(Database db) {
  // final String? itemsJson = await StorageHelper.readData(widget.fileName);
  // var db = Database.fromJson(json)

  return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SafeArea(
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.edit)),
                  Tab(icon: Icon(Icons.folder)),
                ],
                labelColor: Colors.white,
              ),
            )),
        body: TabBarView(children: [
          EntriesView(
              loadEntries: () => db.scratch.entries,
              assignEntries: (List<Entry> entries) {
                logger.i("In assignment");
                db.scratch.entries = entries;
                db.write();
              }),
          EntriesView(
              loadEntries: () => db.scratch.entries,
              assignEntries: (List<Entry> entries) {
                logger.i("In assignment");
                db.scratch.entries = entries;
                db.write();
              })
        ]),
      ));
}

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
  void initState() {
    super.initState();
    var loadEntries = widget.loadEntries();
    setState(() {
      entries = loadEntries;
    });
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
            child: const Text('Add item', style: TextStyle(fontSize: 18))));
  }

  Widget _buildItem(BuildContext context, Entry entry) {
    return Dismissible(
      key: ValueKey(entry),
      secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white)),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.arrow_right, color: Colors.white),
      ),
      // direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _removeItem(entries.indexOf(entry));
        } else if (direction == DismissDirection.startToEnd) {
          _removeItem(entries.indexOf(entry));
          // _moveItem(items.indexOf(item));
        }
      },
      child: ListTile(
        title: Text(entry.content),
        subtitle: Text(entry.created.toString()),
        onTap: () {
          Navigator.restorablePushNamed(context, EntryCard.routeName);
        },
      ),
    );
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

  void _addNewItem(String content) async {
    logger.i("Adding new item");
    Entry entry = Entry(-1, DateTime.now(), DateTime.now(), "title", content);
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
