import 'dart:math';

String formatDateTime(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
}

String getRandomString(int length) {
  const int lowerCaseA = 97;
  const int lowerCaseZ = 122;
  Random random = Random();

  String getRandomChar() {
    int charCode = lowerCaseA + random.nextInt(lowerCaseZ - lowerCaseA + 1);
    return String.fromCharCode(charCode);
  }

  String randomStr = List.generate(length, (_) => getRandomChar()).join();
  return randomStr;
}
