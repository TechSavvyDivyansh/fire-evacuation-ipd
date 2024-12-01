// ignore_for_file: library_private_types_in_public_api

import 'package:app/components/popup.dart';
import 'package:flutter/material.dart';
import 'package:app/components/map.dart';
import 'package:app/components/stream_view.dart';

class FireEvacuationPageWrapper extends StatefulWidget {
  const FireEvacuationPageWrapper({super.key});

  @override
  _FireEvacuationPageWrapperState createState() =>
      _FireEvacuationPageWrapperState();
}

class _FireEvacuationPageWrapperState extends State<FireEvacuationPageWrapper> {
  @override
  void initState() {
    super.initState();
    // Show the popup as soon as the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPopup();
    });
  }

  // Function to show the popup dialog
  void _showPopup() {
    showCustomPopup(
      context,
      "Exit from Stairway 2",
      "Please exit from stairway 2 immediately.",
      () {
        // Close the dialog
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FireEvacuationPage(),
          Align(alignment: Alignment.bottomCenter, child: MapWidget()),
        ],
      ),
    );
  }
}