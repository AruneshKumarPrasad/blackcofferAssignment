import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../Global/global.dart';

class VideoPlayerDetail extends StatefulWidget {
  const VideoPlayerDetail({
    Key? key,
    required this.darkModeEnabled,
    required this.profile,
  }) : super(key: key);

  final bool darkModeEnabled;
  final Map<String, dynamic> profile;

  @override
  State<VideoPlayerDetail> createState() => _VideoPlayerDetailState();
}

class _VideoPlayerDetailState extends State<VideoPlayerDetail> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = false;
  late Duration _duration;
  late Duration _position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(widget.profile["VideoURL"]);
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      _controller.addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
            _duration = _controller.value.duration;
          });
          _position = _controller.value.position;
          if (_position == _duration) {
            _isPlaying = false;
          }
        }
      });
      _controller.setLooping(false);
      _controller.setVolume(1.0);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 15),
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: widget.darkModeEnabled
            ? GlobalTraits.neuShadowsDark
            : GlobalTraits.neuShadows,
        color: widget.darkModeEnabled
            ? GlobalTraits.bgGlobalColorDark
            : GlobalTraits.bgGlobalColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller)),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                          _isPlaying ? _controller.play() : _controller.pause();
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Icon(
                              !_isPlaying ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Stack(
                children: [
                  Image.network(
                    widget.profile["ThumbURL"],
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  ),
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
