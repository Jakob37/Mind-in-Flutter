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
    // direction: DismissDirection.endToStart,
    onDismissed: (direction) {
      // const entryIndex = entries
      if (direction == DismissDirection.endToStart) {
        removeEntry();
        // _removeItem(entries.indexOf(entry));
      } else if (direction == DismissDirection.startToEnd) {
        removeEntry();
        // _removeItem(entries.indexOf(entry));
        // _moveItem(items.indexOf(item));
      }
    },
    child: ListTile(
      title: Text(entry.content),
      subtitle: Text(entry.created.toString()),
      onTap: () {
        Navigator.restorablePushNamed(context, EntryView.routeName);
      },
    ),
  );
}
