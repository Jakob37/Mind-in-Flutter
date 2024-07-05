import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger(printer: PrettyPrinter());

class ConfirmModal extends StatefulWidget {
  final Function(bool) onSubmitted;

  const ConfirmModal({super.key, required this.onSubmitted});

  @override
  ConfirmModalState createState() => ConfirmModalState();
}

class ConfirmModalState extends State<ConfirmModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String selectedOption = "";
  List<String> options = ["Store 1", "Store 2", "Store 3"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select a store"),
      content: SingleChildScrollView(
          child: ListBody(
              children: options
                  .map((option) => ListTile(
                        title: Text(option),
                        selected: selectedOption == option,
                        onTap: () {
                          setState(() {
                            logger.w("Setting option $option");
                            selectedOption = option;
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
            if (selectedOption.isNotEmpty) {
              // widget.onSubmitted(false);
              Navigator.of(context).pop(selectedOption);
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
