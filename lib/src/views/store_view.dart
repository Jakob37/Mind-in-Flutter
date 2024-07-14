import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/_database.dart';
import 'package:mind_flutter/src/util/dbutil.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:mind_flutter/src/views/entry_view.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

Logger logger = Logger(printer: PrettyPrinter());

class StoreViewArguments {
  final Store store;
  final Function() refreshParent;
  final Function(String) assignTitle;
  final Function(List<Entry>) assignEntries;
  StoreViewArguments(
      this.store, this.refreshParent, this.assignTitle, this.assignEntries);
}

class StoreView extends StatefulWidget {
  // final void Function(String, String) assignTitle;
  // final void Function(List<Entry>) assignEntries;
  const StoreView({super.key});
  static const routeName = '/store_view';

  @override
  StoreViewState createState() => StoreViewState();
}

class StoreViewState extends State<StoreView> {
  late TextEditingController _titleController;
  late Store store;
  late List<Entry> displayEntries;
  late Function() refreshParent;
  late Function(String) assignTitle;
  late Function(List<Entry>) assignEntries;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final StoreViewArguments args =
        ModalRoute.of(context)!.settings.arguments as StoreViewArguments;
    store = args.store;
    displayEntries = store.getEntries();
    refreshParent = args.refreshParent;
    assignTitle = args.assignTitle;
    assignEntries = args.assignEntries;
    _titleController.text = store.title;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget getList() {
      return ReorderableListView(
        onReorder: _onReorder,
        children: [
          ...displayEntries.map((item) => _buildItem(context, item)),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: EditText(
            text: store.title,
            onChange: (String newTitle) {
              setState(() {
                store.title = newTitle;
              });
              assignTitle(newTitle);
              refreshParent();
            }),
      ),
      body: SafeArea(child: Column(children: [Expanded(child: getList())])),
      // body: const Center(child: Text('List the entries here')),
      bottomNavigationBar: sharedBottomButton("Add entry to store", () {
        _showModal(context);
      }),
    );
  }

  Widget _buildItem(BuildContext context, Entry entry) {
    EntryViewArguments args = EntryViewArguments(entry, () {
      setState(() {});
    });

    return entryCard(entry, () {
      Navigator.pushNamed(context, EntryView.routeName, arguments: args);
    }, () {
      // logger.w("Removal not implemented");
      int index = displayEntries.indexOf(entry);
      _removeItem(index);
    }, () {
      // logger.w("Removal not implemented");
      int index = displayEntries.indexOf(entry);
      _removeItem(index);
    });
  }

  void _removeItem(int index) async {
    displayEntries.removeAt(index);
    setState(() {});
    assignEntries(displayEntries);
  }

  void _showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => InputModal(
              onSubmitted: (text) {
                setState(() {
                  _addNewEntry(text);
                });
              },
            ));
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Entry item = displayEntries.removeAt(oldIndex);
      displayEntries.insert(newIndex, item);
      assignEntries(displayEntries);
    });
  }

  // FIXME: Do this better
  void _addNewEntry(String text) {
    String entryId = getEntryId();
    Entry entry = Entry(entryId, DateTime.now(), DateTime.now(), text, "");
    store.addEntry(entry);
    displayEntries.add(entry);
    assignEntries(displayEntries);
    setState(() {});
  }
}
