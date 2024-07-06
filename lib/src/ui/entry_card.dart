import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/util.dart';

Widget entryCard(Entry entry, Function() onTap, Function() onDismissLeft,
    Function() onDismissRight,
    {bool showDate = false}) {
  return Dismissible(
    key: ValueKey(entry),
    secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white)),
    background: Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.arrow_right, color: Colors.white),
    ),
    onDismissed: (direction) {
      onDismissLeft();
    },
    confirmDismiss: (direction) async {
      if (direction == DismissDirection.startToEnd) {
        onDismissRight();
        return false;
      }
      return true;
    },
    child: ListTile(
      title: Text(entry.title != "" ? entry.title : "[No title]"),
      subtitle: showDate ? Text(formatDateTime(entry.created)) : null,
      onTap: onTap,
    ),
  );
}
