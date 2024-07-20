import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/_database.dart';
import 'package:mind_flutter/src/settings/settings_controller.dart';
import 'package:mind_flutter/src/settings/settings_view.dart';
import 'package:mind_flutter/src/views/entries_view.dart';
import 'package:mind_flutter/src/views/goals_view.dart';
import 'package:mind_flutter/src/views/placeholder_view.dart';
import 'package:mind_flutter/src/views/stores_view.dart';

Logger logger = Logger(printer: PrettyPrinter());

const String dbFilename = "db.txt";

Widget appMainView(BaseDatabase db, SettingsController controller) {
  // final String? itemsJson = await StorageHelper.readData(widget.fileName);
  // var db = Database.fromJson(json)

  return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: SafeArea(
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.folder)),
                  Tab(icon: Icon(Icons.flag)),
                  Tab(icon: Icon(Icons.timer)),
                  Tab(icon: Icon(Icons.settings)),
                ],
                labelColor: Colors.white,
              ),
            )),
        body: TabBarView(children: [
          EntriesView(
            loadEntries: () => db.getEntriesInStore(scratchStoreId),
            assignEntries: (List<Entry> entries) {
              db.setStoreEntries(scratchStoreId, entries);
              // writeDb(db);
            },
            loadStores: () => db.getStores(),
            addEntryToStore: (String storeId, Entry entry) {
              db.addEntryToStore(storeId, entry);
              // writeDb(db);
            },
          ),
          StoresView(
              loadStores: () => db.getStores(),
              addStore: (Store store) {
                db.addStore(store);
              },
              removeStore: (String storeId) {
                db.removeStore(storeId);
              },
              assignEntries: (String storeId, List<Entry> entries) async {
                await db.setStoreEntries(storeId, entries);
              },
              assignTitle: (String storeId, String title) {
                db.updateStoreTitle(storeId, title);
              }),
          const GoalsView(),
          const PlaceholderView(),
          SettingsView(controller: controller),
        ]),
      ));
}
