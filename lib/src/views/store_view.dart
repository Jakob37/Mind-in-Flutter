import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/ui/bottom_button.dart';
import 'package:mind_flutter/src/ui/edit_title.dart';
import 'package:mind_flutter/src/ui/entry_card.dart';
import 'package:mind_flutter/src/ui/input_modal.dart';
import 'package:mind_flutter/src/util.dart';
import 'package:mind_flutter/src/views/entry_view.dart';

Logger logger = Logger(printer: PrettyPrinter());

class StoreViewArguments {
  final Store store;
  final Function() refreshParent;
  StoreViewArguments(this.store, this.refreshParent);
}

class StoreView extends StatefulWidget {
  final void Function(String, String) assignTitle;
  const StoreView({super.key, required this.assignTitle});
  static const routeName = '/store_view';

  @override
  StoreViewState createState() => StoreViewState();
}

class StoreViewState extends State<StoreView> {
  late TextEditingController _titleController;
  late Store store;
  late Function() refreshParent;

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
    refreshParent = args.refreshParent;
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
          ...store.getEntries().map((item) => _buildItem(context, item)),
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
              widget.assignTitle(store.id, newTitle);
              refreshParent();
            }),
      ),
      body: SafeArea(child: Column(children: [Expanded(child: getList())])),
      // body: const Center(child: Text('List the entries here')),
      bottomNavigationBar: bottomButton("Add entry to store", () {
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
      logger.w("Removal not implemented");
      // int index = entries.indexOf(entry);
      // _removeItem(index);
    });
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
    logger.w("Currently not implemented");
    // setState(() {
    //   if (newIndex > oldIndex) {
    //     newIndex -= 1;
    //   }
    //   Entry entry = store.removeEntryAtIndex(oldIndex);

    //   // entries.insert(newIndex, item);
    //   // widget.assignEntries(entries);
    // });
  }

  void _addNewEntry(String text) {
    String entryId = getEntryId();
    Entry entry = Entry(entryId, DateTime.now(), DateTime.now(), text, "");
    store.addEntry(entry);
    setState(() {});
    refreshParent();
  }
}
