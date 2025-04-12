
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() => runApp(MediaPlayerApp());

class MediaPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Player',
      home: MediaPlayerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MediaPlayerScreen extends StatefulWidget {
  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    // Video background setup
    _videoController = VideoPlayerController.asset('assets/video/sample.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.play();
        setState(() {});
      });

    // Background audio
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource('audio/sample.mp3'));

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideTimer();
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        children: [
          _videoController.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoController.value.size.width,
                      height: _videoController.value.size.height,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                )
              : Container(color: Colors.black),

          if (_showControls)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          _videoController.value.isPlaying
                              ? _videoController.pause()
                              : _videoController.play();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
