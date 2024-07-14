import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/_database.dart';

const storesKey = 'stores';
const entriesKey = 'entries';

class FirebaseDatabase implements BaseDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Entry> getEntryInStore(String storeId, String entryId) async {
    DocumentSnapshot<Map<String, dynamic>> entryDoc =
        await firestore.collection(entriesKey).doc(entryId).get();

    if (entryDoc.exists) {
      Map<String, dynamic>? data = entryDoc.data();
      if (data != null) {
        return Entry.fromJson(data);
      }
    }
    throw ArgumentError("No entry found for entryId $entryId");
  }

  @override
  Future<List<Entry>> getEntriesInStore(String storeId) async {
    Store store = await getStore(storeId);
    return store.getEntries();
  }

  @override
  Future<void> setStoreEntries(String storeId, List<Entry> entries) {
    throw UnimplementedError(
        "This will not be used in Firebase implementation");
  }

  @override
  Future<List<Store>> getStores() async {
    QuerySnapshot<Map<String, dynamic>> storesQuerySnapshot =
        await firestore.collection(storesKey).get();

    return storesQuerySnapshot.docs.map((doc) {
      return Store.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<void> addStore(Store store) async {
    try {
      await firestore.collection(storesKey).doc(store.id).set(store.toJson());
    } catch (e) {
      throw Exception("Unable to add store: $e");
    }
  }

  @override
  Future<void> removeStore(String storeId) async {
    try {
      await firestore.collection(storesKey).doc(storeId).delete();
    } catch (e) {
      throw Exception("Unable to remove store: $e");
    }
  }

  @override
  Future<Store> getStore(String storeId) async {
    DocumentSnapshot<Map<String, dynamic>> storeDoc =
        await firestore.collection(storesKey).doc(storeId).get();

    if (!storeDoc.exists) {
      throw ArgumentError("No store found for storeId $storeId");
    }

    Map<String, dynamic>? data = storeDoc.data();

    if (data == null) {
      throw ArgumentError("Data for storeId $storeId is null");
    }

    return Store.fromJson(data);
  }

  @override
  Future<void> addEntryToStore(String storeId, Entry entry) async {
    firestore.collection(entriesKey).doc(entry.id).set(entry.toJson());
  }

  @override
  Future<void> updateEntryTitle(
      String storeId, String entryId, String title) async {
    DocumentReference entryRef = firestore.collection(entriesKey).doc(entryId);
    await entryRef.update({"title": title});
  }

  @override
  Future<void> updateEntryInStore(String storeId, Entry entry) async {
    DocumentReference entryRef = firestore.collection(entriesKey).doc(entry.id);
    await entryRef.update(entry.toJson());
  }

  @override
  Future<void> updateStoreTitle(String storeId, String title) {
    throw UnimplementedError();
  }
}
