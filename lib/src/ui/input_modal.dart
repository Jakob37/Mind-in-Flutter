import 'package:flutter/material.dart';

class InputModal extends StatefulWidget {
  final Function(String) onSubmitted;

  const InputModal({super.key, required this.onSubmitted});

  @override
  InputModalState createState() => InputModalState();
}

class InputModalState extends State<InputModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Enter your thoughts"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "..."),
        autofocus: true,
        focusNode: _focusNode,
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmitted(_controller.text);
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
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
