import 'package:logger/logger.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/storage_helper.dart';

Logger logger = Logger(printer: PrettyPrinter());

void writeDb(Database db) {
  StorageHelper.writeData(db.toJsonString(), dbFileName);
}
