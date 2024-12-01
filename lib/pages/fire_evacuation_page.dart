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
    showCustomPopup(context, 'Enter Your current location');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FireEvacuationPage(),
          Align(alignment: Alignment.bottomCenter, child: MapWidget()),
          Positioned(
            top: 20, // Adjust for padding
            right: 20, // Adjust for padding
            child: ElevatedButton(
              onPressed: _showPopup,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                shape: CircleBorder(),
                backgroundColor: Colors.redAccent,
              ),
              child: Icon(Icons.location_on, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
