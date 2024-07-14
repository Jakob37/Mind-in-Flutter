import 'package:flutter/material.dart';
import 'package:mind_flutter/src/config.dart';
import 'package:mind_flutter/src/db/_database.dart';

Widget storeCard(BuildContext context, Store store, Function() onPressed,
    Function() onIconPressed) {
  return Container(
      key: ValueKey(store),
      child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: ListTile(
              title: Text(store.title),
              onTap: onPressed,
              trailing: store.id != scratchStoreId
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: onIconPressed)
                  : null)));
}
