import 'package:flutter/material.dart';
import 'package:mind_flutter/src/storage_helper.dart';

import '../database.dart';
import '../ui/input_modal.dart';
import 'sample_item_details_view.dart';

import 'dart:convert';

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
        body:
            TabBarView(children: [ItemListView(db: db), ItemListView(db: db)]),
      ));
}

class ItemListView extends StatefulWidget {
  const ItemListView({super.key, required Database db});

  static const routeName = '/';

  @override
  ItemListViewState createState() => ItemListViewState();
}

class ItemListViewState extends State<ItemListView> {
  List<Entry> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // @override
  Widget build(BuildContext context) {
    Widget getList() {
      return ReorderableListView(
        onReorder: _onReorder,
        children: [
          ...items.map((item) => _buildItem(context, item)),
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

  Widget _buildItem(BuildContext context, Entry item) {
    return Dismissible(
      key: ValueKey(item),
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
          _removeItem(items.indexOf(item));
        } else if (direction == DismissDirection.startToEnd) {
          _removeItem(items.indexOf(item));
          // _moveItem(items.indexOf(item));
        }
      },
      child: ListTile(
        title: Text(item.content),
        onTap: () {
          Navigator.restorablePushNamed(
              context, SampleItemDetailsView.routeName);
        },
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Entry item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
      _storeItems();
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

  void _loadItems() async {
    print("FIXME: loadItems");
    // final String? itemsJson = await StorageHelper.readData(widget.fileName);
    // if (itemsJson != null) {
    //   setState(() {
    //     items = List<Entry>.from(
    //         json.decode(itemsJson).map((x) => Entry.fromJson(x)));
    //   });
    // }
  }

  void _addNewItem(String content) async {
    print("FIXME: addNewItem");
    // final int nextId = items.isEmpty ? 1 : items.last.id + 1;
    // final newItem = Entry(nextId, content);
    // items.add(newItem);
    // _storeItems();
    // setState(() {});
  }

  void _addToStore(String content) async {}

  void _storeItems() async {
    print("FIXME: storeItems");
    // final prefsString = json.encode(items.map((x) => x.toJson()).toList());
    // await StorageHelper.writeData(prefsString, widget.fileName);
  }

  void _removeItem(int index) async {
    print("FIXME: removeItem");
    // items.removeAt(index);
    // setState(() {});
    // _storeItems();
  }

  // void _moveItem(int index) async {
  //   var item = items[index];
  //   items.removeAt(index);
  //   setState(() {});
  //   _storeItems();

  //   _addToStore(item.content);
  // }
}
