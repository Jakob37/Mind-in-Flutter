import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/views/entries_view.dart';
import 'package:mind_flutter/src/views/stores_view.dart';

Logger logger = Logger(printer: PrettyPrinter());

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
        body: TabBarView(children: [
          EntriesView(
              loadEntries: () => db.scratch.entries,
              assignEntries: (List<Entry> entries) {
                logger.i("Assigning entries");
                db.scratch.entries = entries;
                db.write();
              }),
          StoresView(
              loadStores: () => db.stores,
              assignStores: (List<Store> stores) {
                logger.i("Assigning stores");
                db.stores = stores;
                db.write();
              })
        ]),
      ));
}
