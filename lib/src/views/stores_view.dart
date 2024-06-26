import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/ui/bottom_button.dart';
import 'package:mind_flutter/src/ui/confirm_modal.dart';
import 'package:mind_flutter/src/ui/input_modal.dart';
import 'package:mind_flutter/src/ui/store_card.dart';
import 'package:mind_flutter/src/util.dart';
import 'package:mind_flutter/src/views/store_view.dart';

Logger logger = Logger(printer: PrettyPrinter());

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
        bottomNavigationBar:
            bottomButton("Add store", () => _showModal(context)));
  }

  Widget _buildStore(BuildContext context, Store store) {
    return storeCard(context, store, () {
      logger.i("Open another entries page here");
      Navigator.pushNamed(context, StoreView.routeName,
          arguments: StoreViewArguments(store, () {
            setState(() {});
          }));
    }, () {
      _showConfirmModal(context, () {
        _removeStore(stores.indexOf(store));
      });
    });
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
        builder: (BuildContext context) => ConfirmModal(onSubmitted: (yes) {
              if (yes) {
                // _removeStore(index)
                removeStore();
              }
            }));
  }

  void _addNewStore(String title) async {
    String storeId = getStoreId();
    Store store = Store(storeId, DateTime.now(), DateTime.now(), title, {});
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
