import 'package:app/components/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class FireExecutionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mjpeg(
        stream: 'http://192.168.1.9:5000/video_feed',
        isLive: true,
      ),
    );
  }
}
