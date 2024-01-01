import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCountdown extends StatefulWidget {
  final Function onVideoComplete;

  const VideoCountdown({super.key, required this.onVideoComplete});

  @override
  VideoCountdownState createState() => VideoCountdownState();
}

class VideoCountdownState extends State<VideoCountdown> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/Olympialaiset.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        widget.onVideoComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
