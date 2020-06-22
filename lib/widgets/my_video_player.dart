import 'package:flutter/material.dart';
import 'package:flutteryoutubeclone/constants/size.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class MyVideoPlayer extends StatefulWidget {
  final Duration _duration = Duration(milliseconds: 200);

  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _controller;
  AnimationController _iconAnimation;
  bool showController = true;
  double curPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          showController = true;
        });
      }, onError: (e) => print(e));
    _controller.setLooping(true);
    _controller.addListener(() async {
      curPosition = (await _controller.position).inSeconds.toDouble();
      setState(() {});
    });
    _iconAnimation =
        AnimationController(duration: widget._duration, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.initialized
          ? _controller.value.aspectRatio
          : 1920 / 1080,
      child: _controller.value.initialized ? _videoFrame() : Container(),
    );
  }

  Stack _videoFrame() {
    return Stack(
      children: <Widget>[
        VideoPlayer(_controller),
        AnimatedContainer(
            duration: widget._duration,
            color: showController ? Colors.black45 : Colors.transparent,
            child: showController
                ? _videoController()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showController = true;
                        startTimerForControllerToDisappear();
                      });
                    },
                    child: Container(
                      height: size.width / 1920 * 1080,
                      width: size.width,
                      color: Colors.transparent,
                    ))),
      ],
    );
  }

  IgnorePointer _videoController() {
    return IgnorePointer(
      ignoring: !showController,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.skip_previous),
              IconButton(
                  onPressed: () {
                    if (_iconAnimation.isDismissed) {
                      _iconAnimation.forward();
                      if (_controller.value.initialized) {
                        _controller.play();
                        startTimerForControllerToDisappear();
                      }
                    }
                    if (_iconAnimation.isCompleted) {
                      _iconAnimation.reverse();
                      if (_controller.value.isPlaying) _controller.pause();
                    }
                  },
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    size: 36,
                    progress: _iconAnimation,
                  )),
              Icon(Icons.skip_next)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          Transform.translate(
            offset: Offset(0, 24),
            child: SliderTheme(
              data: SliderThemeData(
                  trackShape: CustomTrackShape(),
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0)),
              child: Slider(
                activeColor: Colors.redAccent,
                inactiveColor: Colors.grey,
                onChanged: (double value) {
                  setState(() {
                    _controller.seekTo(Duration(seconds: value.toInt()));
                  });
                },
                value: curPosition,
                max: _controller.value.duration.inSeconds.toDouble(),
                min: 0.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  startTimerForControllerToDisappear() {
    return new Timer(Duration(seconds: 3), disappearController);
  }

  disappearController() {
    setState(() {
      if (_controller.value.isPlaying) showController = false;
    });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(0, trackTop, size.width, trackHeight);
  }
}
