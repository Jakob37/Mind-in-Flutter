import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/_database.dart';
import 'package:mind_flutter/src/db/storage_helper.dart';
import 'package:mind_flutter/src/util/util.dart';

Logger logger = Logger(printer: PrettyPrinter());

void writeDb(Database db, {bool verbose = false}) {
  if (verbose) {
    logger.i(db.toJsonString());
  }
  StorageHelper.writeData(db.toJsonString(), dbFileName);
}

String getId(String base) {
  int idLength = 10;
  String randomStr = getRandomString(idLength);
  return "$base-$randomStr";
}

String getEntryId() {
  return getId("entry");
}

String getStoreId() {
  return getId("store");
}

Store getStore(String title) {
  String storeId = getStoreId();
  Store store = Store(storeId, DateTime.now(), DateTime.now(), title, {});
  return store;
}

Entry getEmptyEntry(String title) {
  String id = getEntryId();
  Entry entry = Entry(id, DateTime.now(), DateTime.now(), title, "");
  return entry;
}
