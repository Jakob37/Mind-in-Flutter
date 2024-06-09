import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/database.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  String dbPath = "db_test.txt";
  Database db = await setupDatabase(dbPath);

  runApp(MindApp(db: db, settingsController: settingsController));
}

Future<Database> setupDatabase(String dbPath) async {
  return await Database.init(dbPath);
  // try {
  // } catch (e) {
  //   // logger.w(e.);
  //   logger.w("Proceeding with an empty db");
  //   // logger
  //   //     .w("DB in $dbPath not valid or not found, initializing a new database");
  //   Store scratch = Store(-1, DateTime.now(), DateTime.now(), "scratch", []);
  //   Database db = Database(dbPath, scratch, []);
  //   await db.write();
  //   return db;
  // }
}
