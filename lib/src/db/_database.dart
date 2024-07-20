import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/entities.dart';
import 'package:mind_flutter/src/db/storage_helper.dart';
import 'package:path_provider/path_provider.dart';

Logger logger = Logger(printer: PrettyPrinter());

class Database {
  Map<String, Store> stores;

  Database(this.stores);

  static Future<Database> init(String filepath) async {
    logger.i("Init db");

    final String? jsonString = await StorageHelper.readData(filepath);
    logger.i(jsonString);
    if (jsonString == null || jsonString.isEmpty) {
      throw FormatException("Invalid json in $filepath");
    }

    try {
      final dynamic myJson = json.decode(jsonString);

      if (myJson is! Map<String, dynamic>) {
        throw FormatException(
            "Expected JSON object but got ${myJson.runtimeType}");
      }

      Map<String, dynamic> storeJsons =
          myJson['stores'] as Map<String, dynamic>? ?? {};

      Map<String, Store> newStores = storeJsons.map((key, storeJson) {
        return MapEntry(key, Store.fromJson(storeJson as Map<String, dynamic>));
      });

      return Database(newStores);
    } catch (e) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String filePath =
          '${documentsDirectory.path}/invalid_json_${DateTime.now().millisecondsSinceEpoch}.json';
      final File file = File(filePath);
      await file.writeAsString(jsonString);

      logger.e("Invalid JSON saved to ${file.path}");
      throw FormatException("Error parsing JSON: ${e.toString()}");
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, Map<String, dynamic>> storeJsons =
        stores.map((key, store) => MapEntry(key, store.toJson()));

    return {"stores": storeJsons};
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  Future<Entry?> getEntryInStore(String storeId, String entryId) {
    Store store = stores['storeId'] as Store;
    Entry entry = store.getEntry(entryId);
    return Future.value(entry);
  }

  Future<List<Entry>> getEntriesInStore(String storeId) {
    Store store = stores[storeId] as Store;
    return Future.value(store.entries.values.toList());
  }

  Future<void> setStoreEntries(String storeId, List<Entry> entries) {
    Store store = stores[storeId] as Store;
    store.entries =
        Map.fromEntries(entries.map((entry) => MapEntry(entry.id, entry)));
    return Future.value(null);
  }

  Future<List<Store>> getStores() {
    return Future.value(stores.values.toList());
  }

  Future<void> addEntryToStore(String storeId, Entry entry) async {
    Store store = await getStore(storeId);
    store.addEntry(entry);
    return Future.value(null);
  }

  Future<void> setStores(List<Store> myStores) {
    stores =
        Map.fromEntries(myStores.map((store) => MapEntry(store.id, store)));
    return Future.value(null);
  }

  Future<Store> getStore(String storeId) {
    return Future.value(stores[storeId] as Store);
  }

  Future<void> updateEntryTitle(
      String storeId, String entryId, String entryTitle) async {
    Store store = await getStore(storeId);
    Entry entry = store.getEntry(entryId);
    entry.title = entryTitle;
    return Future.value(null);
  }

  Future<void> updateStoreTitle(String storeId, String title) async {
    Store store = await getStore(storeId);
    store.title = title;
    return Future.value(null);
  }
}
