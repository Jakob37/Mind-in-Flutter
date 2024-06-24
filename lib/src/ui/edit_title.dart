import 'package:flutter/material.dart';

class EditText extends StatefulWidget {
  final String text;
  final Function(String) onChange;
  const EditText({super.key, required this.text, required this.onChange});

  @override
  EditTextState createState() => EditTextState();
}

class EditTextState extends State<EditText> {
  bool _isEditing = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: _isEditing
              ? TextField(
                  controller: _textController,
                  autofocus: true,
                  onSubmitted: (newValue) {
                    widget.onChange(newValue);
                    setState(() {
                      _isEditing = false;
                    });
                  },
                )
              : Text(_textController.text.isEmpty
                  ? "Enter text"
                  : _textController.text)),
      IconButton(
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          onPressed: () {
            setState(() {
              if (_isEditing) {
                widget.onChange(_textController.text);
                _isEditing = false;
              } else {
                _isEditing = true;
              }
            });
          })
    ]);
  }
}
