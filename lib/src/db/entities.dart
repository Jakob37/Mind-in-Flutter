import 'dart:convert';

// abstract class DbEntity {
//   final String id;
//   final DateTime created;

//   Map<String, dynamic> toJson();

//   DbEntity(this.id, this.created)
// }

typedef JSON = Map<String, dynamic>;

abstract class Entity {
  void toJson();
  Entity fromJson(JSON json);
}

class Store implements Entity {
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

  @override
  JSON toJson() {
    return {
      "id": id.toString(),
      "created": created.toIso8601String(),
      "lastChanged": lastChanged.toIso8601String(),
      "title": title,
      "entries": entries.map((key, entry) => MapEntry(key, entry.toJson()))
    };
  }

  @override
  Store fromJson(JSON json) {
    return Store.fromJson(json);
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

class Entry implements Entity {
  final String id;
  final DateTime created;
  DateTime lastChanged;
  String title;
  String content;

  Map<String, String>? customAttributes;

  List<Entry> childEntries;

  Entry(this.id, this.created, this.lastChanged, this.title, this.content,
      this.childEntries,
      [this.customAttributes]);

  String toJsonString() {
    return json.encode(toJson());
  }

  @override
  JSON toJson() {
    JSON obj = {
      'id': id.toString(),
      'created': created.toIso8601String(),
      'lastChanged': lastChanged.toIso8601String(),
      'title': title,
      'content': content,
      'childEntries': childEntries,
    };
    if (customAttributes != null) {
      obj['customAttributes'] = customAttributes;
    }
    return obj;
  }

  @override
  Entry fromJson(JSON json) {
    return Entry.fromJson(json);
  }

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
      json['id'] as String,
      DateTime.parse(json['created']),
      DateTime.parse(json['lastChanged']),
      json['title'] as String,
      json['content'] as String,
      parseOptionalList(Entry.fromJson, json['childEntries']),
      json['customAttributes'] != null
          ? Map<String, String>.from(json['customAttributes'])
          : null);
}

List<Entity> parseOptionalList<Entity>(
    Entity Function(JSON json) createFn, List<JSON>? origJson) {
  if (origJson == null) {
    return [];
  }

  return origJson.map((childJson) => createFn(childJson)).toList();
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
