import 'package:flutter/material.dart';

Widget bottomButton(String text, Function() onPressed) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(0)),
      child: Text(text, style: const TextStyle(fontSize: 18)));
}
