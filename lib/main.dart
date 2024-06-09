import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  Database db = await Database.init("db_test.txt");

  runApp(MindApp(db: db, settingsController: settingsController));
}
