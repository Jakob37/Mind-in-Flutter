import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/entities.dart';
import 'package:mind_flutter/src/settings/settings_controller.dart';
import 'package:mind_flutter/src/settings/settings_view.dart';
import 'package:mind_flutter/src/views/entries_view.dart';
import 'package:mind_flutter/src/views/goals_view.dart';
import 'package:mind_flutter/src/views/log_view.dart';

Logger logger = Logger(printer: PrettyPrinter());

const String dbFilename = "db.txt";

class AbstractViewData {
  final Icon tabIcon;
  final Widget view;

  AbstractViewData(this.tabIcon, this.view);
}

class EntriesViewData extends AbstractViewData {
  EntriesViewData(BaseDatabase db)
      : super(
          const Icon(Icons.home),
          EntriesView(
            loadEntries: () => db.getEntriesInStore(scratchStoreId),
            assignEntries: (List<Entry> entries) {
              db.setStoreEntries(scratchStoreId, entries);
            },
            loadStores: () => db.getStores(),
            addEntryToStore: (String storeId, Entry entry) {
              db.addEntryToStore(storeId, entry);
            },
          ),
        );
}

class StoresViewData extends AbstractViewData {
  StoresViewData(BaseDatabase db)
      : super(
          const Icon(Icons.folder),
          EntriesView(
            loadEntries: () => db.getEntriesInStore(scratchStoreId),
            assignEntries: (List<Entry> entries) {
              db.setStoreEntries(scratchStoreId, entries);
            },
            loadStores: () => db.getStores(),
            addEntryToStore: (String storeId, Entry entry) {
              db.addEntryToStore(storeId, entry);
            },
          ),
        );
}

class GoalsViewData extends AbstractViewData {
  GoalsViewData()
      : super(
          const Icon(Icons.flag),
          const GoalsView(),
        );
}

class LogViewData extends AbstractViewData {
  LogViewData()
      : super(
          const Icon(Icons.history),
          const LogView(),
        );
}

class SettingsViewData extends AbstractViewData {
  SettingsViewData(SettingsController settingsController)
      : super(
          const Icon(Icons.settings),
          SettingsView(controller: settingsController),
        );
}

Widget appMainView(BaseDatabase db, SettingsController settingsController) {
  AbstractViewData entriesView = EntriesViewData(db);
  AbstractViewData storesView = StoresViewData(db);
  AbstractViewData goalsView = GoalsViewData();
  AbstractViewData logView = LogViewData();
  AbstractViewData settingsView = SettingsViewData(settingsController);

  List<AbstractViewData> views = [
    entriesView,
    storesView,
    goalsView,
    logView,
    settingsView
  ];

  return DefaultTabController(
      length: views.length,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: SafeArea(
              child: TabBar(
                tabs: views.map((view) => Tab(icon: view.tabIcon)).toList(),
                labelColor: Colors.white,
              ),
            )),
        body: TabBarView(children: views.map((view) => view.view).toList()),
      ));
}
