import 'package:flutter/material.dart';

class PlaceholderView extends StatefulWidget {
  const PlaceholderView({super.key});

  @override
  PlaceholderViewState createState() => PlaceholderViewState();
}

class PlaceholderViewState extends State<PlaceholderView> {
  @override
  Widget build(BuildContext context) {
  return const Text("This is a placeholder");
  }
}
