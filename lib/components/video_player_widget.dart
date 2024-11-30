import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('http://192.168.1.9:5000/video_feed')
      ..initialize().then((_) {
        // Start autoplay after the video is initialized
        _controller.play();
        setState(() {});
      })
      ..setLooping(true); // Set looping to true if required
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(), // Show loading indicator until video is ready
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
