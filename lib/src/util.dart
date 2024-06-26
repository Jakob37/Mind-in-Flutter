import 'dart:math';

import 'package:mind_flutter/src/database.dart';

String formatDateTime(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
}

String getRandomString(int length) {
  const int lowerCaseA = 97;
  const int lowerCaseZ = 122;
  Random random = Random();

  String getRandomChar() {
    int charCode = lowerCaseA + random.nextInt(lowerCaseZ - lowerCaseA + 1);
    return String.fromCharCode(charCode);
  }

  String randomStr = List.generate(length, (_) => getRandomChar()).join();
  return randomStr;
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
