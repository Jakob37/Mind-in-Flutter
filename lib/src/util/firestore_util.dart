import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/db/database.dart';
import 'package:mind_flutter/src/util/dbutil.dart';

Logger logger = Logger(printer: PrettyPrinter());

Future<void> addEntryToFirestore(Entry entry) async {
  CollectionReference entries =
      FirebaseFirestore.instance.collection('entries');
  Entry testEntry = getEmptyEntry("Test entry");
  try {
    await entries.add({
      'id': testEntry.id,
      'created': testEntry.created,
      'lastChanged': testEntry.lastChanged,
      'title': testEntry.title,
      'content': testEntry.content
    });
    logger.i("Entry added to Firestore");
  } catch (e) {
    logger.e("Failed to add entry: $e");
  }
}
