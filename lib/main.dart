import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mind_flutter/src/database.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

Logger logger = Logger(printer: PrettyPrinter());

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  String dbPath = "db_test.txt";
  Database db;
  try {
    db = await Database.init(dbPath);
  } catch (e) {
    logger.w("DB in $dbPath not valid, setting up a new");
    // FIXME: Should be careful here, this is for empty file
    Store scratch = Store(-1, DateTime.now(), DateTime.now(), "scratch", []);
    db = Database(dbPath, scratch, []);
    db.write();
  }

  runApp(MindApp(db: db, settingsController: settingsController));
}
