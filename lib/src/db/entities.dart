import 'dart:convert';

// abstract class DbEntity {
//   final String id;
//   final DateTime created;

//   Map<String, dynamic> toJson();

//   DbEntity(this.id, this.created)
// }

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
}

class Entry {
  final String id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  String content;

  Map<String, String>? customAttributes;

  Entry(this.id, this.created, this.lastChanged, this.title, this.content,
      [this.customAttributes]);

  String toJsonString() {
    return json.encode(toJson());
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> obj = {
      'id': id.toString(),
      'created': created.toIso8601String(),
      'lastChanged': lastChanged.toIso8601String(),
      'title': title,
      'content': content,
    };
    if (customAttributes != null) {
      obj['customAttributes'] = customAttributes;
    }
    return obj;
  }

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
      json['id'] as String,
      DateTime.parse(json['created']),
      DateTime.parse(json['lastChanged']),
      json['title'] as String,
      json['content'] as String,
      json['customAttributes'] != null
          ? Map<String, String>.from(json['customAttributes'])
          : null);
}

// class JournalLog {
//   final String id;
//   final DateTime created;
//   DateTime lastChanged;
//   String title;
//   List<Entry> entries;
//   int? durationMs;

//   JournalLog(this.id, this.created, this.lastChanged, this.title, this.entries);
// }
