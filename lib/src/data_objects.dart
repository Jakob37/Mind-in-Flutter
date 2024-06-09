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
}

class Store {
  final int id;
  List<Entry> entries;

  Store(this.id, this.entries);

  String toJson() {
    return jsonEncode({
      "id": id.toString(),
      "entries": jsonEncode(entries.map((entry) => jsonEncode(entry)))
    });
  }

  factory Store.fromJson(Map<String, dynamic> json) {
    int id = int.parse(json['id']);
    List<Entry> entries = json['entries'] as List<Entry>;
    return Store(id, entries);
  }
}

class Entry {
  final int id;
  final String content;

  const Entry(this.id, this.content);

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'content': content,
      };

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        int.parse(json['id']),
        json['content'] as String,
      );
}
