// import 'package:app/components/popup.dart';
// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:app/components/GridBackground.dart';
import 'package:app/components/live_map.dart';
import 'package:app/utils/semicirclular_clipper.dart';
import 'package:flutter/material.dart';
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
      // _showPopup();
    });
  }

  // Function to show the popup dialog
  // void _showPopup() {
  //   showCustomPopup(context, 'Enter Your current location');
  // }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const FireEvacuationPage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: SemicircleClipper(),
              child: Container(
                color: const Color.fromARGB(216, 253, 253, 253),
                width: double.infinity,
                height: 420,
                child: Stack(
                  children: [
                    const Positioned.fill(child: GridBackground()),
                    Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: const LiveMap(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
