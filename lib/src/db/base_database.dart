import 'package:mind_flutter/src/db/database.dart';

abstract class BaseDatabase {
  Future<Entry?> getEntryInStore(String storeId, String entryId);
  Future<List<Entry>> getEntries(String storeId);
  Future<void> setEntries(String storeId, List<Entry> entries);
  Future<List<Store>> getStores();
  Future<Store> getStore(String storeId);
  Future<void> addEntryToStore(String storeId, Entry entry);
  Future<void> setStores(List<Store> stores);
  Future<void> updateEntryTitle(
      String storeId, String entryId, String entryTitle);
  Future<void> updateStoreTitle(String storeId, String title);
}
