import 'package:flutter/material.dart';

class LogView extends StatefulWidget {
  const LogView({super.key});

  @override
  LogViewState createState() => LogViewState();
}

class LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    return const Text("This is the start of the log view");
  }
}
