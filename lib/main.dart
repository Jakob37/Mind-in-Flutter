import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/util/dbutil.dart';
import 'package:mind_flutter/src/storage_helper.dart';

import 'src/app.dart';
import 'src/config.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  Database db = Database({});
  // Database db = await setupDatabase(dbFileName);
  // Database db = await setupDatabase(dbFileName);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: firebaseApiKey,
          appId: firebaseAppId,
          messagingSenderId: firebaseMessagingSenderId,
          projectId: firebaseProjectId,
          storageBucket: firebaseStorageBucket));
  logger.i("Firebase initialized!");

  // await addEntryToFirestore(getEmptyEntry("Test entry"));

  runApp(MindApp(db: db, settingsController: settingsController));
}

// Future<Database> setupDatabase(String dbFileName) async {
//   if (!await StorageHelper.fileExists(dbFileName)) {
//     logger.i("File not found, creating a new file at $dbFileName (in doc dir)");
//     // await file.create(recursive: true);

//     final defaultDb = makeEmptyDb();
//     StorageHelper.writeData(defaultDb.toJsonString(), dbFileName);
//   }

//   return await Database.init(dbFileName);
// }

// // FIXME: Many things to think through here
// Database makeEmptyDb() {
//   Store scratch =
//       Store(scratchStoreId, DateTime.now(), DateTime.now(), 'Scratch', {});
//   return Database({scratchStoreId: scratch});
// }
