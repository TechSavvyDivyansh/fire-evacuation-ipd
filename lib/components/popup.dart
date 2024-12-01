import 'package:flutter/material.dart';

class CustomPopupDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onOkPressed;

  const CustomPopupDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onOkPressed,
          child: Text("OK"),
        ),
      ],
    );
  }
}

void showCustomPopup(BuildContext context, String title, String content,
    VoidCallback onOkPressed) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing the dialog by tapping outside
    builder: (BuildContext context) {
      return CustomPopupDialog(
        title: title,
        content: content,
        onOkPressed: onOkPressed,
      );
    },
  );
}
