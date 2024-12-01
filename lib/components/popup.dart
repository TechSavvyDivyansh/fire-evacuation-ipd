import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomPopupDialog extends StatefulWidget {
  final String title;
  final Function onClose; // Callback to close the popup when OK is pressed

  const CustomPopupDialog(
      {super.key, required this.title, required this.onClose});

  @override
  _CustomPopupDialogState createState() => _CustomPopupDialogState();
}

class _CustomPopupDialogState extends State<CustomPopupDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendPosition() async {
    final String position = _controller.text;

    if (position.isEmpty) {
      _showApiResponseDialog("Position cannot be empty!");
      return;
    }

    setState(() {
      _isLoading = true; // Show a loader
    });

    try {
      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse('http://192.168.1.9:5000/shortestPath'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'current_location': position}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final apiResponse = responseData['exit'] ?? "No response!";
        _showApiResponseDialog("Exit: $apiResponse");
      } else {
        _showApiResponseDialog("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      _showApiResponseDialog("Error: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide the loader
      });
    }
  }

  void _showApiResponseDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("API Response"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the API response dialog
                widget.onClose(); // Close the input dialog as well
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Enter current position",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          if (_isLoading)
            const CircularProgressIndicator(), // Show loader while API is called
        ],
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(context).pop(), // Close the input dialog
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _sendPosition,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}

void showCustomPopup(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return CustomPopupDialog(
        title: title,
        onClose: () {
          Navigator.of(context).pop(); // Close the input dialog
        },
      );
    },
  );
}
