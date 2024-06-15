import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/ui/input_modal.dart';

class StoresView extends StatefulWidget {
  final List<Store> Function() loadStores;
  final void Function(List<Store>) assignStores;

  const StoresView(
      {super.key, required this.loadStores, required this.assignStores});

  // FIXME: ?
  static const routeName = '/';

  @override
  StoresViewState createState() => StoresViewState();
}

class StoresViewState extends State<StoresView> {
  List<Store> stores = [];

  @override
  void initState() {
    super.initState();
    var loadStores = widget.loadStores();
    setState(() {
      stores = loadStores;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getList() {
      return ReorderableListView(onReorder: _onReorder, children: [
        ...stores.map((store) => _buildStore(context, store)),
      ]);
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          child: const Text('Add store', style: TextStyle(fontSize: 18))),
    );
  }

  Widget _buildStore(BuildContext context, Store store) {
    return Dismissible(
        key: ValueKey(store), child: ListTile(title: Text("Store")));
  }

  void _onReorder(int oldIndex, int newIndex) {}

  void _showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) => InputModal(
              onSubmitted: (value) {
                setState(() {
                  _addNewStore(value);
                });
              },
            ));
  }

  void _addNewStore(String content) async {
    Store store = Store(-1, DateTime.now(), DateTime.now(), "Store", []);
    stores.add(store);
    widget.assignStores(stores);
    setState(() {});
  }
}
