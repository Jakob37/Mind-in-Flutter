import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/database.dart';

const storesKey = 'stores';
const entriesKey = 'entries';

class FirebaseDatabase implements BaseDatabase {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Entry?> getEntryInStore(String storeId, String entryId) async {
    DocumentSnapshot<Map<String, dynamic>> storeDoc =
        await firestore.collection(entriesKey).doc(entryId).get();

    if (storeDoc.exists) {
      Map<String, dynamic>? data = storeDoc.data();
      if (data != null) {
        return Entry.fromJson(data);
      }
    }
    return null;
  }

  @override
  Future<List<Entry>> getEntries(String storeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> setEntries(String storeId, List<Entry> entries) {
    throw UnimplementedError();
  }

  @override
  Future<List<Store>> getStores() {
    throw UnimplementedError();
  }

  @override
  Future<Store> getStore(String storeId) {
    throw UnimplementedError();
  }

  @override
  Future<void> addEntryToStore(String storeId, Entry entry) {
    throw UnimplementedError();
  }

  @override
  Future<void> setStores(List<Store> stores) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateEntryTitle(
      String storeId, String entryId, String entryTitle) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateStoreTitle(String storeId, String title) {
    throw UnimplementedError();
  }
}
