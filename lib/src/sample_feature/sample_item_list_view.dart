import 'package:flutter/material.dart';

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
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return ListTile(
              title: Text(item.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeItem(index),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  SampleItemDetailsView.routeName,
                );
              });
        },
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
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString('items');
    print("Obtaining itemsJson $itemsJson");
    if (itemsJson != null) {
      setState(() {
        items = List<SampleItem>.from(
            json.decode(itemsJson).map((x) => SampleItem.fromJson(x)));
      });
    }
  }

  void _addNewItem(String content) async {
    final prefs = await SharedPreferences.getInstance();
    final int nextId = items.isEmpty ? 1 : items.last.id + 1;
    final newItem = SampleItem(nextId, content);
    items.add(newItem);
    final prefsString = json.encode(items.map((x) => x.toJson()).toList());
    await prefs.setString('items', prefsString);
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter your input"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Text .."),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSubmitted(_controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
