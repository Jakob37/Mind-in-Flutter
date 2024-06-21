import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:mind_flutter/src/storage_helper.dart';

Logger logger = Logger(printer: PrettyPrinter());

// void writeDb(Database db, String path) async {
//   String dbJsonStr = db.toJsonString();
//   logger.i("Writing $dbJsonStr");
//   await StorageHelper.writeData(dbJsonStr, path);
// }

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
  }

  Map<String, dynamic> toJson() {
    Map<String, Map<String, dynamic>> storeJsons =
        stores.map((key, store) => MapEntry(key, store.toJson()));

    return {"stores": storeJsons};
  }

  String toJsonString() {
    return json.encode(toJson());
  }

  Entry? getEntryInStore(String storeId, String entryId) {
    Store store = stores['storeId'] as Store;
    Entry entry = store.getEntry(entryId);
    return entry;
  }

  List<Entry> getEntries(String storeId) {
    Store store = stores[storeId] as Store;
    return store.entries.values.toList();
  }

  void setEntries(String storeId, List<Entry> entries) {
    Store store = stores[storeId] as Store;
    store.entries =
        Map.fromEntries(entries.map((entry) => MapEntry(entry.id, entry)));
  }

  List<Store> getStores() {
    return stores.values.toList();
  }

  void setStores(List<Store> myStores) {
    stores =
        Map.fromEntries(myStores.map((store) => MapEntry(store.id, store)));
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
    return entries['entryId'] as Entry;
  }
}

class Entry {
  final String id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  String content;

  Entry(this.id, this.created, this.lastChanged, this.title, this.content);

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
