import 'dart:convert';

class Database {
  Store scratch;
  List<Store> stores;

  Database(this.scratch, this.stores);

  String toJson() {
    String scratchJson = scratch.toJson();
    List<String> storeJsons = stores.map((store) => store.toJson()).toList();

    return jsonEncode(
        {"scrach": scratchJson, "stores": jsonEncode(storeJsons)});
  }

  factory Database.fromJson(Map<String, dynamic> json) {
    var scratch = Store.fromJson(json['scratch']);
    // FIXME: How to handle the decode of the array?
    var stores = jsonDecode(json['stores']);

    return Database(scratch, stores);
  }
}

class Store {
  final int id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  List<Entry> entries;

  Store(this.id, this.created, this.lastChanged, this.title, this.entries);

  String toJson() {
    return jsonEncode({
      "id": id.toString(),
      "created": created.toString(),
      "lastChanged": lastChanged.toString(),
      "entries": jsonEncode(entries.map((entry) => jsonEncode(entry)))
    });
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    var id = int.parse(json['id']);
    var created = DateTime.parse(json['id']);
    var lastChanged = DateTime.parse(json['id']);
    var title = json['title'] as String;
    var entries = json['entries'] as List<Entry>;
    return Store(id, created, lastChanged, title, entries);
  }
}

class Entry {
  final int id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  String content;

  Entry(this.id, this.created, this.lastChanged, this.title, this.content);

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'created': created,
        'lastChanged': lastChanged,
        'title': title,
        'content': content,
      };

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        int.parse(json['id']),
        DateTime.parse(json['created']),
        DateTime.parse(json['lastChanged']),
        json['title'] as String,
        json['content'] as String,
      );
}
