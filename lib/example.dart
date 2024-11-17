import 'package:flutter/material.dart';
import 'package:native_video_player/native_video_player.dart';

class Example extends StatefulWidget {
  const Example({super.key, required this.title});

  final String title;

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  NativeVideoPlayerController? _nativeController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeController?.onPlaybackStatusChanged
        .removeListener(_onPlaybackPositionChanged);
    _nativeController?.onPlaybackPositionChanged
        .removeListener(_onPlaybackPositionChanged);
    _nativeController?.onPlaybackEnded.removeListener(() {});
    _nativeController = null;
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
              AspectRatio(
                aspectRatio: 16 / 9,
                child: NativeVideoPlayerView(
                  onViewReady: _initController,
                ),
              ),
              if (_nativeController?.videoInfo case final videoInfo?)
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      LinearProgressIndicator(
                        value: videoInfo.duration.toDouble(),
                        valueColor: const AlwaysStoppedAnimation(
                          Colors.transparent,
                        ),
                        backgroundColor: Colors.grey.withOpacity(0.5),
                      ),
                      LinearProgressIndicator(
                        value:
                            (_nativeController?.playbackInfo?.position ?? 0.0) /
                                videoInfo.duration,
                        valueColor: const AlwaysStoppedAnimation(Colors.red),
                        backgroundColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPlaybackPositionChanged() {
    setState(() {});
  }

  Future<void> _initController(NativeVideoPlayerController controller) async {
    _nativeController = controller;

    final videoSource = await _createVideoSource();
    await _nativeController?.loadVideoSource(videoSource);

    _nativeController?.play();

    _nativeController?.onPlaybackStatusChanged
        .addListener(_onPlaybackPositionChanged);
    _nativeController?.onPlaybackPositionChanged
        .addListener(_onPlaybackPositionChanged);

    _nativeController?.onPlaybackEnded.addListener(() {
      controller.play(); // loop
    });
  }

  Future<VideoSource> _createVideoSource() async {
    return VideoSource.init(
      path:
          'https://storage.googleapis.com/exoplayer-test-media-0/BigBuckBunny_320x180.mp4',
      type: VideoSourceType.network,
    );
  }
}
