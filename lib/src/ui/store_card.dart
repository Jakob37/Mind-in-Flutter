import 'package:flutter/material.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/_database.dart';

Widget storeCard(BuildContext context, Store store, Function() onPressed,
    Function() onIconPressed) {
  String nbrEntries = store.entries.length.toString();
  return Container(
      key: ValueKey(store),
      child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: ListTile(
              title: Text("${store.title} ($nbrEntries)"),
              onTap: onPressed,
              trailing: store.id != scratchStoreId
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: onIconPressed)
                  : null)));
}
