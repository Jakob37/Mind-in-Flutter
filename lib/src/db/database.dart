import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/storage_helper.dart';
import 'package:path_provider/path_provider.dart';

Logger logger = Logger(printer: PrettyPrinter());

class Database implements BaseDatabase {
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

  @override
  Future<Entry?> getEntryInStore(String storeId, String entryId) {
    Store store = stores['storeId'] as Store;
    Entry entry = store.getEntry(entryId);
    return Future.value(entry);
  }

  @override
  Future<List<Entry>> getEntries(String storeId) {
    Store store = stores[storeId] as Store;
    return Future.value(store.entries.values.toList());
  }

  @override
  Future<void> setEntries(String storeId, List<Entry> entries) {
    Store store = stores[storeId] as Store;
    store.entries =
        Map.fromEntries(entries.map((entry) => MapEntry(entry.id, entry)));
    return Future.value(null);
  }

  @override
  Future<List<Store>> getStores() {
    return Future.value(stores.values.toList());
  }

  @override
  Future<void> addEntryToStore(String storeId, Entry entry) async {
    Store store = await getStore(storeId);
    store.addEntry(entry);
    return Future.value(null);
  }

  @override
  Future<void> setStores(List<Store> myStores) {
    stores =
        Map.fromEntries(myStores.map((store) => MapEntry(store.id, store)));
    return Future.value(null);
  }

  @override
  Future<Store> getStore(String storeId) {
    return Future.value(stores[storeId] as Store);
  }

  @override
  Future<void> updateEntryTitle(
      String storeId, String entryId, String entryTitle) async {
    Store store = await getStore(storeId);
    Entry entry = store.getEntry(entryId);
    entry.title = entryTitle;
    return Future.value(null);
  }

  @override
  Future<void> updateStoreTitle(String storeId, String title) async {
    Store store = await getStore(storeId);
    store.title = title;
    return Future.value(null);
  }
}

class Store {
  final String id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  Map<String, Entry> entries;

  Store(this.id, this.created, this.lastChanged, this.title, this.entries);

  Entry? findEntry(String entryId) {
    if (!entries.containsKey(entryId)) {
      return null;
    }
    return entries[entryId] as Entry;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "created": created.toIso8601String(),
      "lastChanged": lastChanged.toIso8601String(),
      "title": title,
      "entries": entries.map((key, entry) => MapEntry(key, entry.toJson()))
    };
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String;
    DateTime created = DateTime.parse(json['created']);
    DateTime lastChanged = DateTime.parse(json['lastChanged']);
    String title = json['title'] ??= "[Placeholder]";
    Map<String, Entry> entries =
        (json['entries'] as Map<String, dynamic>? ?? {}).map((key, entryJson) =>
            MapEntry(key, Entry.fromJson(entryJson as Map<String, dynamic>)));
    return Store(id, created, lastChanged, title, entries);
  }

  Entry getEntry(String entryId) {
    return entries[entryId] as Entry;
  }

  void addEntry(Entry entry) {
    entries[entry.id] = entry;
  }

  List<Entry> getEntries() {
    return entries.values.toList();
  }

  void removeEntry(String entryId) {
    entries.remove(entryId);
  }

  Entry getEntryAtIndex(int index) {
    List<Entry> entries = getEntries();
    Entry entry = entries[index];
    return entry;
  }

  // Entry removeEntryAtIndex(int index) {
  //   // Entry entry = getEntryAtIndex(index);
  //   // entries.remove(entry.id);
  //   // return entry;
  // }
}

class Entry {
  final String id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  String content;

  Entry(this.id, this.created, this.lastChanged, this.title, this.content);

  String toJsonString() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'created': created.toIso8601String(),
        'lastChanged': lastChanged.toIso8601String(),
        'title': title,
        'content': content,
      };

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        json['id'] as String,
        DateTime.parse(json['created']),
        DateTime.parse(json['lastChanged']),
        json['title'] as String,
        json['content'] as String,
      );
}
