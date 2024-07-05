import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(printer: PrettyPrinter());

class Option {
  final String id;
  final String displayText;

  Option({required this.id, required this.displayText});
}

class SelectModal extends StatefulWidget {
  final Function(bool) onSubmitted;
  final List<Option> options;

  const SelectModal(
      {super.key, required this.onSubmitted, required this.options});

  @override
  SelectModalState createState() => SelectModalState();
}

class SelectModalState extends State<SelectModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String selectedOptionId = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select a store"),
      content: SingleChildScrollView(
          child: ListBody(
              children: widget.options
                  .map((Option option) => ListTile(
                        title: Text(option.displayText),
                        selected: selectedOptionId == option.id,
                        onTap: () {
                          setState(() {
                            selectedOptionId = option.id;
                          });
                        },
                      ))
                  .toList())),
      actions: [
        TextButton(
          onPressed: () {
            // widget.onSubmitted(false);
            Navigator.of(context).pop(null);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (selectedOptionId.isNotEmpty) {
              // widget.onSubmitted(false);
              Navigator.of(context).pop(selectedOptionId);
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
