import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  // static const String fileName = 'data.txt';

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<File> writeData(String data, String fileName) async {
    final file = await _localFile(fileName);
    return file.writeAsString(data);
  }

  static Future<String?> readData(String fileName) async {
    try {
      final file = await _localFile(fileName);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return 'Error: $e';
    }
  }
}
