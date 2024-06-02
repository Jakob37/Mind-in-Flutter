import 'package:flutter/material.dart';
import 'package:mind_flutter/src/storage_helper.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ReorderableListView(
        // restorationId: 'sampleItemListView',
        // itemCount: items.length,
        onReorder: _onReorder,
        children: [
          for (int index = 0; index < items.length; index++)
            ListTile(
                key: ValueKey(items[index]),
                title: Text(items[index].content),
                onTap: () {
                  Navigator.restorablePushNamed(
                    context,
                    SampleItemDetailsView.routeName,
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeItem(index),
                ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showModal(context),
          backgroundColor: Colors.deepPurple,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.add, size: 30)),
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
      builder: (BuildContext context) => _InputModal(
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
    final String? itemsJson = await StorageHelper.readData();
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
    await StorageHelper.writeData(prefsString);
  }

  void _removeItem(int index) async {
    setState(() {
      items.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'items', json.encode(items.map((x) => x.toJson()).toList()));
  }
}

class _InputModal extends StatefulWidget {
  final Function(String) onSubmitted;

  const _InputModal({Key? key, required this.onSubmitted}) : super(key: key);

  @override
  _InputModalState createState() => _InputModalState();
}

class _InputModalState extends State<_InputModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter your thoughts"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "..."),
        autofocus: true,
        focusNode: _focusNode,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmitted(_controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
