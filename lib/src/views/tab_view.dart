import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/util/dbutil.dart';
import 'package:mind_flutter/src/views/entries_view.dart';
import 'package:mind_flutter/src/views/stores_view.dart';

Logger logger = Logger(printer: PrettyPrinter());

const String dbFilename = "db.txt";

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
            loadEntries: () => db.getEntries(scratchStoreId),
            assignEntries: (List<Entry> entries) {
              db.setEntries(scratchStoreId, entries);
              writeDb(db);
            },
            loadStores: () => db.getStores(),
            addEntryToStore: (String storeId, Entry entry) {
              db.addEntryToStore(storeId, entry);
              writeDb(db);
            },
          ),
          StoresView(
              loadStores: () => db.getStores(),
              assignStores: (List<Store> stores) {
                db.setStores(stores);
                writeDb(db);
              },
              assignEntries: (String storeId, List<Entry> entries) {
                logger.w(
                    "storeId $storeId entries ${entries.map((entry) => entry.toJsonString())}");
                db.setEntries(storeId, entries);
                writeDb(db);
              },
              assignTitle: (String storeId, String title) {
                db.updateStoreTitle(storeId, title);
                writeDb(db);
              })
        ]),
      ));
}
