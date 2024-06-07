import 'package:flutter/material.dart';
import 'package:mind_flutter/src/storage_helper.dart';

import '../sample_item.dart';
import '../ui/input_modal.dart';
import 'sample_item_details_view.dart';

import 'dart:convert';

Widget appTabsView() {
  return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SafeArea(
                child: TabBar(tabs: [
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.folder)),
            ]))),
        body: TabBarView(children: [
          // Icon(Icons.edit),
          SampleItemListView(fileName: "data.txt"),
          SampleItemListView(fileName: "store.txt"),
          // Icon(Icons.folder),
          // const Icon(Icons.folder),
        ]),
      ));
}

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  final String fileName;
  const SampleItemListView({Key? key, required this.fileName})
      : super(key: key);

  static const routeName = '/';

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  List<SampleItem> items = [];

  // final List<SampleItem> items;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return _listView();
  //   Scaffold(
  //       // DefaultTabController(
  //       // length: 2,
  //       // child: Scaffold(
  //       appBar: const PreferredSize(
  //         // title: Text('Tab Example'),
  //         preferredSize: Size.fromHeight(kToolbarHeight),
  //         child: SafeArea(
  //             child: TabBar(
  //           tabs: [
  //             Tab(icon: Icon(Icons.edit)),
  //             Tab(icon: Icon(Icons.folder)),
  //           ],
  //         )),
  //       ),
  //       body: TabBarView(children: [
  //         _listView(),
  //         _listView(),
  //         // const Icon(Icons.folder),
  //       ]));
  //   // ));
  // }

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

  Widget _buildItem(BuildContext context, SampleItem item) {
    return Dismissible(
      key: ValueKey(item),
      background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          child: const Icon(Icons.delete, color: Colors.white)),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        _removeItem(items.indexOf(item));
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
      final SampleItem item = items.removeAt(oldIndex);
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
    // final prefs = await SharedPreferences.getInstance();
    // final String? itemsJson = prefs.getString('items');
    final String? itemsJson = await StorageHelper.readData(widget.fileName);
    if (itemsJson != null) {
      setState(() {
        items = List<SampleItem>.from(
            json.decode(itemsJson).map((x) => SampleItem.fromJson(x)));
      });
    }
  }

  void _addNewItem(String content) async {
    // final prefs = await SharedPreferences.getInstance();
    final int nextId = items.isEmpty ? 1 : items.last.id + 1;
    final newItem = SampleItem(nextId, content);
    items.add(newItem);
    _storeItems();
    setState(() {});
  }

  void _storeItems() async {
    final prefsString = json.encode(items.map((x) => x.toJson()).toList());
    await StorageHelper.writeData(prefsString, widget.fileName);
  }

  void _removeItem(int index) async {
    items.removeAt(index);
    setState(() {});
    _storeItems();
  }
}
