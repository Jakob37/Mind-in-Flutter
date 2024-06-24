import 'package:flutter/material.dart';

class ConfirmModal extends StatefulWidget {
  final Function(bool) onSubmitted;

  const ConfirmModal({super.key, required this.onSubmitted});

  @override
  ConfirmModalState createState() => ConfirmModalState();
}

class ConfirmModalState extends State<ConfirmModal> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Confirm"),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSubmitted(false);
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmitted(true);
            // widget.onSubmitted(_controller.text);
            Navigator.of(context).pop();
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
