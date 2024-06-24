import 'package:flutter/material.dart';
import 'package:mind_flutter/src/database.dart';
import 'package:mind_flutter/src/ui/edit_title.dart';

class StoreViewArguments {
  final Store store;
  final Function() refreshParent;
  StoreViewArguments(this.store, this.refreshParent);
}

class StoreView extends StatefulWidget {
  final void Function(String, String) assignTitle;
  const StoreView({super.key, required this.assignTitle});
  static const routeName = '/store_view';

  @override
  StoreViewState createState() => StoreViewState();
}

class StoreViewState extends State<StoreView> {
  late TextEditingController _titleController;
  late Store store;
  late Function() refreshParent;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final StoreViewArguments args =
        ModalRoute.of(context)!.settings.arguments as StoreViewArguments;
    store = args.store;
    refreshParent = args.refreshParent;
    _titleController.text = store.title;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: EditText(
              text: store.title,
              onChange: (String newTitle) {
                setState(() {
                  store.title = newTitle;
                });
                widget.assignTitle(store.id, newTitle);
                refreshParent();
              }),
        ),
        body: const Center(child: Text('List the entries here')));
  }
}
