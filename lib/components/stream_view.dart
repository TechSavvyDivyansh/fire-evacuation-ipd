// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class FireEvacuationPage extends StatelessWidget {
  const FireEvacuationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.scale(
          scale: 2.6,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: Mjpeg(
              stream: 'http://192.168.1.9:5002/video_feed',
              isLive: true,
            ),
          ),
        ),
      ],
    );
  }
}
