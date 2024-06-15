import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/ui/confirm_modal.dart';
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
    return Container(
        key: ValueKey(store),
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: ListTile(
                title: Text(store.title),
                trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _showConfirmModal(context, () {
                        _removeStore(stores.indexOf(store));
                      });
                    }))));
  }

  void _onReorder(int oldIndex, int newIndex) {}

  void _showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => InputModal(
              onSubmitted: (text) {
                setState(() {
                  _addNewStore(text);
                });
              },
            ));
  }

  void _showConfirmModal(BuildContext context, Function removeStore) {
    showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmModal(onSubmitted: (value) {
              logger.i("Confirm modal result: $value");
              if (value) {
                // _removeStore(index)
                removeStore();
              }
            }));
  }

  void _addNewStore(String title) async {
    Store store = Store(-1, DateTime.now(), DateTime.now(), title, []);
    stores.add(store);
    setState(() {});
    widget.assignStores(stores);
  }

  void _removeStore(int index) async {
    logger.i("remove store");
    stores.removeAt(index);
    setState(() {});
    widget.assignStores(stores);
  }
}
