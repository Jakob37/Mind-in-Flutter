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
}
