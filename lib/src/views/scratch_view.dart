import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/dbutil.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:mind_flutter/src/views/entry_view.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

import 'package:mind_flutter/src/db/entities.dart';

Logger logger = Logger(printer: PrettyPrinter());

class ScratchView extends StatefulWidget {
  final Future<List<Entry>> Function() loadEntries;
  final Future<List<Store>> Function() loadStores;
  final void Function(List<Entry>) assignEntries;
  final void Function(String storeId, Entry entry) addEntryToStore;

  const ScratchView(
      {super.key,
      required this.loadEntries,
      required this.assignEntries,
      required this.loadStores,
      required this.addEntryToStore});

  // Used in app.dart
  static const routeName = '/';

  @override
  ScratchViewState createState() => ScratchViewState();
}

class ScratchViewState extends State<ScratchView> {
  List<Entry> entries = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    List<Entry> myEntries = await widget.loadEntries();
    if (mounted) {
      setState(() {
        entries = myEntries;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getList() {
      return ReorderableListView(
        onReorder: _onReorder,
        children: [
          ...entries.map((item) => _buildEntryCard(context, item)),
        ],
      );
    }

    return Scaffold(
        body: SafeArea(child: Column(children: [Expanded(child: getList())])),
        bottomNavigationBar:
            sharedBottomButton("Add entry", () => _showModal(context)));
  }

  Widget _buildEntryCard(BuildContext context, Entry entry) {
    void assignTitle(String title) {
      setState(() {});
    }

    void assignContent(String content) {
      setState(() {});
    }

    EntryViewArguments args =
        EntryViewArguments(entry, assignTitle, assignContent);

    onDismissLeft() {
      int index = entries.indexOf(entry);
      _removeEntry(index);
    }

    onDismissRight() async {
      String? storeId = await _showTransferModal(context);

      if (storeId != null) {
        int index = entries.indexOf(entry);
        Entry removedEntry = await _removeEntry(index);
        widget.addEntryToStore(storeId, removedEntry);
      }
    }

    return entryCard(entry, () {
      Navigator.pushNamed(context, EntryView.routeName, arguments: args);
    }, onDismissLeft, onDismissRight);
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
    List<Store> stores = await widget.loadStores();

    if (!mounted) {
      return null;
    }

    List<Option> options = stores
        .map((store) => Option(id: store.id, displayText: store.title))
        .toList();

    String? result = await _showSelectModal(options);

    return result;
  }

  Future<String?> _showSelectModal(List<Option> options) {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) => SelectModal(
          onSubmitted: (confirmed) {
            return confirmed;
          },
          options: options),
    );
  }

  void _addNewItem(String title) async {
    Entry entry = createEmptyEntry(title);
    entries.add(entry);
    widget.assignEntries(entries);
    setState(() {});
  }

  Future<Entry> _removeEntry(int index) async {
    Entry removedEntry = entries.removeAt(index);
    setState(() {});
    widget.assignEntries(entries);
    return removedEntry;
  }
}
