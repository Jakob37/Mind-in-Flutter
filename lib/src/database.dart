import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:mind_flutter/src/storage_helper.dart';

Logger logger = Logger(printer: PrettyPrinter());

class Database {
  final String filepath;
  Store scratch;
  List<Store> stores;

  Database(this.filepath, this.scratch, this.stores);

  Future<void> write() async {
    var dbJson = toJson();
    var jsonString = jsonEncode(dbJson);
    await StorageHelper.writeData(jsonString, filepath);
    logger.i("$jsonString written to $filepath");
  }

  static Future<Database> init(String filepath) async {
    final String? jsonString = await StorageHelper.readData(filepath);
    logger.i("Loaded $jsonString from $filepath");
    if (jsonString == null) {
      throw FormatException("Invalid json in $filepath");
    }
    final myJson = json.decode(jsonString);
    var newScratch = Store.fromJson(myJson['scratch']);
    var newStores = (myJson['stores'] as List<dynamic>? ?? [])
        .map((storeJson) => Store.fromJson(storeJson as Map<String, dynamic>))
        .toList();
    return Database(filepath, newScratch, newStores);
  }

  Map<String, dynamic> toJson() {
    logger.i("Before scratch toJson");
    Map<String, dynamic> scratchJson = scratch.toJson();
    List<Map<String, dynamic>> storeJsons =
        stores.map((store) => store.toJson()).toList();

    return {"scratch": scratchJson, "stores": storeJsons};
  }
}

class Store {
  final int id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  List<Entry> entries;

  Store(this.id, this.created, this.lastChanged, this.title, this.entries);

  Entry? findEntry(String entryId) {
    for (Entry entry in entries) {
      if (entry.id == entryId) {
        return entry;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "created": created.toIso8601String(),
      "lastChanged": lastChanged.toIso8601String(),
      "title": title,
      "entries": entries.map((entry) => entry.toJson()).toList()
    };
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    int id = int.parse(json['id']);
    DateTime created = DateTime.parse(json['created']);
    DateTime lastChanged = DateTime.parse(json['lastChanged']);
    String title = json['title'] ??= "[Placeholder]";
    List<Entry> entries = (json['entries'] as List<dynamic>? ?? [])
        .map((entryJson) => Entry.fromJson(entryJson as Map<String, dynamic>))
        .toList();
    return Store(id, created, lastChanged, title, entries);
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
