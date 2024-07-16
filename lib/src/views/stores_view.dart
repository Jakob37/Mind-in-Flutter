import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:mind_flutter/src/db/_database.dart';
import 'package:mind_flutter/src/util/dbutil.dart';
import 'package:mind_flutter/src/ui/store_card.dart';
import 'package:mind_flutter/src/views/store_view.dart';
import 'package:shared_flutter_code/shared_flutter_code.dart';

Logger logger = Logger(printer: PrettyPrinter());

class StoresView extends StatefulWidget {
  final Future<List<Store>> Function() loadStores;
  final void Function(Store) addStore;
  final void Function(String) removeStore;
  final Future<void> Function(String storeId, List<Entry> entries)
      assignEntries;
  final void Function(String storeId, String title) assignTitle;

  const StoresView(
      {super.key,
      required this.loadStores,
      required this.addStore,
      required this.removeStore,
      required this.assignEntries,
      required this.assignTitle});

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
    _loadStores();
  }

  _loadStores() async {
    List<Store> locStores = await widget.loadStores();
    setState(() {
      stores = locStores;
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
        bottomNavigationBar:
            sharedBottomButton("Add store", () => _showModal(context)));
  }

  Widget _buildStore(BuildContext context, Store store) {
    return storeCard(context, store, () {
      void assignTitle(String title) {
        widget.assignTitle(store.id, title);
        setState(() {});
      }

      void assignEntries(List<Entry> entries) async {
        await widget.assignEntries(store.id, entries);
        // setState(() {});
        _loadStores();
      }

      Navigator.pushNamed(context, StoreView.routeName,
          arguments: StoreViewArguments(store, assignTitle, assignEntries));
    }, () {
      _showConfirmModal(context, () {
        _removeStore(stores.indexOf(store));
      });
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Store item = stores.removeAt(oldIndex);
      stores.insert(newIndex, item);
      widget.removeStore(item.id);
    });
  }

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
        builder: (BuildContext context) => ConfirmModal(onSubmitted: (yes) {
              if (yes) {
                // _removeStore(index)
                removeStore();
              }
            }));
  }

  void _addNewStore(String title) async {
    Store store = createStore(title);
    stores.add(store);
    setState(() {});
    widget.addStore(store);
  }

  void _removeStore(int index) async {
    Store removedStore = stores.removeAt(index);
    setState(() {});
    widget.removeStore(removedStore.id);
  }
}
