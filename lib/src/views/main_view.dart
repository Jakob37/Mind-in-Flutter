import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/entities.dart';
import 'package:mind_flutter/src/settings/settings_controller.dart';
import 'package:mind_flutter/src/settings/settings_view.dart';
import 'package:mind_flutter/src/views/scratch_view.dart';
import 'package:mind_flutter/src/views/goals_view.dart';
import 'package:mind_flutter/src/views/journal_view.dart';
import 'package:mind_flutter/src/views/stores_view.dart';

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
          ScratchView(
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
        );
}

class GoalsViewData extends AbstractViewData {
  GoalsViewData()
      : super(
          const Icon(Icons.flag),
          const GoalsView(),
        );
}

class JournalViewData extends AbstractViewData {
  JournalViewData()
      : super(
            const Icon(Icons.edit),
            JournalView(
                loadEntries: () => Future.value([]),
                addEntry: (Entry entry) => {},
                removeEntry: (String entryId) => {}));
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
  // AbstractViewData goalsView = GoalsViewData();
  AbstractViewData logView = JournalViewData();
  AbstractViewData settingsView = SettingsViewData(settingsController);

  List<AbstractViewData> views = [
    entriesView,
    // goalsView,
    logView,
    storesView,
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
