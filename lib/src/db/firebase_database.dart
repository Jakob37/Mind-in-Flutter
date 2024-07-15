import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/_database.dart';

const storesKey = 'stores';
// const entriesKey = 'entries';
const scratchStoreId = 'scratch';

class FirebaseDatabase implements BaseDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> ensureSetup() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> storeDoc =
          await firestore.collection(storesKey).doc(scratchStoreId).get();

      if (!storeDoc.exists) {
        // Store scratchStore = createStore(scratchStoreId);
        String storeId = scratchStoreId;
        Store scratchStore =
            Store(storeId, DateTime.now(), DateTime.now(), "Scratch", {});

        await addStore(scratchStore);
      }
    } catch (e) {
      throw Exception("Error checking/adding scratch store: $e");
    }
  }

  @override
  Future<Entry> getEntryInStore(String storeId, String entryId) async {
    DocumentSnapshot<Map<String, dynamic>> storeDoc =
        await firestore.collection(storesKey).doc(storeId).get();

    if (storeDoc.exists) {
      Map<String, dynamic>? data = storeDoc.data();
      if (data != null) {
        Store store = Store.fromJson(data);
        return store.getEntry(entryId);
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
  Future<void> setStoreEntries(String storeId, List<Entry> entries) async {
    Store store = await getStore(storeId);
    // store.entries = entries;
    Map<String, Entry> entriesMap = {
      for (var entry in entries) entry.id: entry
    };
    store.entries = entriesMap;
    saveStore(store);
  }

  @override
  Future<List<Store>> getStores() async {
    QuerySnapshot<Map<String, dynamic>> storesQuerySnapshot =
        await firestore.collection(storesKey).get();

    List<Store> stores = storesQuerySnapshot.docs.map((doc) {
      return Store.fromJson(doc.data());
    }).toList();

    return stores;
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
    Store store = await getStore(storeId);
    store.addEntry(entry);
    // firestore.collection(storesKey).doc(storeId).set(entry.toJson());
    saveStore(store);
  }

  @override
  Future<void> updateEntryTitle(
      String storeId, String entryId, String title) async {
    Store store = await getStore(storeId);
    Entry entry = store.getEntry(entryId);
    entry.title = title;
    saveStore(store);
  }

  @override
  Future<void> updateEntryInStore(
      String storeId, String entryId, String title, String content) async {
    Store store = await getStore(storeId);
    Entry entryRef = store.getEntry(entryId);
    entryRef.title = title;
    entryRef.content = content;
    saveStore(store);
  }

  @override
  Future<void> updateStoreTitle(String storeId, String title) async {
    Store store = await getStore(storeId);
    store.title = title;
    saveStore(store);
  }

  Future<void> saveStore(Store store) async {
    firestore.collection(storesKey).doc(store.id).set(store.toJson());
  }
}
