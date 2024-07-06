import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/dbutil.dart';
import 'package:mind_flutter/src/ui/bottom_button.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:mind_flutter/src/ui/select_modal.dart';
import 'package:mind_flutter/src/views/entry_view.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

import '../database.dart';
import '../ui/input_modal.dart';

Logger logger = Logger(printer: PrettyPrinter());

class EntriesView extends StatefulWidget {
  final List<Entry> Function() loadEntries;
  final List<Store> Function() loadStores;
  final void Function(List<Entry>) assignEntries;
  final void Function(String storeId, Entry entry) addEntryToStore;

  const EntriesView(
      {super.key,
      required this.loadEntries,
      required this.assignEntries,
      required this.loadStores,
      required this.addEntryToStore});

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
        bottomNavigationBar:
            bottomButton("Add entry", () => _showModal(context)));
  }

  Widget _buildItem(BuildContext context, Entry entry) {
    EntryViewArguments args = EntryViewArguments(entry, () {
      setState(() {});
    });

    return entryCard(entry, () {
      Navigator.pushNamed(context, EntryView.routeName, arguments: args);
    }, () {
      int index = entries.indexOf(entry);
      _removeEntry(index);
    }, () async {
      String? storeId = await _showTransferModal(context);
      if (storeId != null) {
        int index = entries.indexOf(entry);
        Entry removedEntry = await _removeEntry(index);

        widget.addEntryToStore(storeId, removedEntry);
      }
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

  Future<String?> _showTransferModal(BuildContext context) async {
    List<Store> stores = widget.loadStores();
    List<Option> options = stores
        .map((store) => Option(id: store.id, displayText: store.title))
        .toList();

    final result = await showDialog<String?>(
      context: context,
      builder: (BuildContext context) => SelectModal(
          onSubmitted: (confirmed) {
            return confirmed;
          },
          options: options),
    );

    return result;
  }

  void _addNewItem(String title) async {
    Entry entry = getEmptyEntry(title);
    entries.add(entry);
    widget.assignEntries(entries);
    setState(() {});

    Calculator calc = Calculator();
    logger.w("Calc results: ${calc.addOne(2)}");
  }

  Future<Entry> _removeEntry(int index) async {
    Entry removedEntry = entries.removeAt(index);
    setState(() {});
    widget.assignEntries(entries);
    return removedEntry;
  }
}
