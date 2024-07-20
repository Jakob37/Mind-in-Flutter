import 'package:mind_flutter/src/db/entities.dart';

abstract class BaseDatabase {
  Future<void> ensureSetup();

  Future<void> addStore(Store store);
  Future<void> removeStore(String storeId);
  Future<List<Store>> getStores();
  Future<Store> getStore(String storeId);
  Future<void> updateStoreTitle(String storeId, String title);

  Future<List<Entry>> getEntriesInStore(String storeId);
  Future<Entry> getEntryInStore(String storeId, String entryId);
  Future<void> setStoreEntries(String storeId, List<Entry> entries);
  Future<void> addEntryToStore(String storeId, Entry entry);
  Future<void> updateEntryInStore(
      String storeId, String entryId, String title, String content);
  Future<void> updateEntryTitle(
      String storeId, String entryId, String entryTitle);
}
