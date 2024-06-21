import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/storage_helper.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  Database db = await setupDatabase(dbFileName);

  runApp(MindApp(db: db, settingsController: settingsController));
}

Future<Database> setupDatabase(String dbFileName) async {
  // final directory = await getApplicationDocumentsDirectory();
  // final dbPath = '${directory.path}/$dbFileName';
  // final file = File(dbPath);

  // StorageHelper.writeData(data, fileName)

  if (!await StorageHelper.fileExists(dbFileName)) {
    logger.i("File not found, creating a new file at $dbFileName (in doc dir)");
    // await file.create(recursive: true);

    final defaultDb = makeEmptyDb();
    StorageHelper.writeData(defaultDb.toJsonString(), dbFileName);
  }

  return await Database.init(dbFileName);
}

// FIXME: Many things to think through here
Database makeEmptyDb() {
  Store scratch =
      Store(scratchStoreId, DateTime.now(), DateTime.now(), 'Scratch', {});
  return Database({scratchStoreId: scratch});
}
