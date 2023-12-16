// VideoPlayerWidget class for playing video
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerr extends StatefulWidget {
  final String url;

  VideoPlayerr({required this.url});

  @override
  _VideoPlayerrState createState() => _VideoPlayerrState();
}

class _VideoPlayerrState extends State<VideoPlayerr> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
      _isPlaying = !_controller.value.isPlaying;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
