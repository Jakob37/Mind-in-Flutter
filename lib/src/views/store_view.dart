import 'package:flutter/material.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  static const routeName = '/store_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Store title'),
        ),
        body: const Center(child: Text('List the entries here')));
  }
}
