import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Uint8List videoBytes;

  const VideoPlayerWidget({super.key, required this.videoBytes});

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadVideo() async {
    // ایجاد URL داده‌ای از بایت‌ها
    final videoBase64 = base64Encode(widget.videoBytes as List<int>);
    final videoDataUrl = 'data:video/mp4;base64,$videoBase64';

    _controller = VideoPlayerController.networkUrl(Uri.parse(videoDataUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isInitialized && _controller != null
          ? AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      )
          : const CircularProgressIndicator(),
    );
  }
}
