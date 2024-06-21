import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/util.dart';

Widget entryCard(Entry entry, Function() onTap, Function() onDismiss,
    {bool showDate = false}) {
  return Dismissible(
    key: ValueKey(entry),
    secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white)),
    background: Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.arrow_right, color: Colors.white),
    ),
    onDismissed: (direction) {
      if (direction == DismissDirection.endToStart) {
        onDismiss();
      } else if (direction == DismissDirection.startToEnd) {
        onDismiss();
      }
    },
    child: ListTile(
      title: Text(entry.title != "" ? entry.title : "[No title]"),
      subtitle: showDate ? Text(formatDateTime(entry.created)) : null,
      onTap: onTap,
    ),
  );
}
