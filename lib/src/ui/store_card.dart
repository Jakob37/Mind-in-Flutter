import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';

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
              trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: onIconPressed))));
}
