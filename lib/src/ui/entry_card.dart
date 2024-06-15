import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/views/entry_view.dart';

Widget entryCard(BuildContext context, Entry entry, Function() removeEntry) {
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
        removeEntry();
      } else if (direction == DismissDirection.startToEnd) {
        removeEntry();
      }
    },
    child: ListTile(
      title: Text(entry.content),
      subtitle: Text(formatDateTime(entry.created)),
      onTap: () {
        Navigator.restorablePushNamed(context, EntryView.routeName);
      },
    ),
  );
}

String formatDateTime(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
}
