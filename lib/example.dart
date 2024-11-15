import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Example extends StatefulWidget {
  const Example({super.key, required this.title});

  final String title;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://storage.googleapis.com/exoplayer-test-media-0/BigBuckBunny_320x180.mp4'))
      ..initialize().then((_) {
        _controller.play();
      })
      ..setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SizedBox(
                height: 200,
                child: VideoPlayer(_controller),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                child:
                    VideoProgressIndicator(_controller, allowScrubbing: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
