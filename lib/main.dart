import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/base_database.dart';
import 'package:mind_flutter/src/db/firebase_database.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:firebase_core/firebase_core.dart';

Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: firebaseApiKey,
          appId: firebaseAppId,
          messagingSenderId: firebaseMessagingSenderId,
          projectId: firebaseProjectId,
          storageBucket: firebaseStorageBucket));
  logger.i("Firebase initialized!");
  BaseDatabase db = FirebaseDatabase();
  await db.ensureSetup();

  // await ensureScratchStoreExists(db);

  runApp(MindApp(db: db, settingsController: settingsController));
}

// Future<void> ensureScratchStoreExists(BaseDatabase db) async {
//   try {
//     Store scratchStore = await db.getStore('scratch');
//     logger.i("Scratch store exists");
//   } catch (e) {
//     logger.i("Scratch store does not exist. Creating ...");
//     Store scratchStore = getStore('Store');
//     await db.
//   }
// }

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
