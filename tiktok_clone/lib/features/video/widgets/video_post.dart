import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset("assets/videos/soondol.mp4");

  late final AnimationController _animationController;

  bool _isPaused = false;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  void _onVideoChange() {
    // 사용자의 영상 길이 == 현재 사용자 영상 상태
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      //onVideoFinished -> 다음 페이지로 넘김
      widget.onVideoFinished();
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();

    setState(() {});
    _videoPlayerController.addListener(_onVideoChange);
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5, // default
      duration: _animationDuration,
    );
    _animationController.addListener(() {
      // print(_animationController.value);
      //-> _animationController는 1.0 1.1 1.2 ... 1.5까지를 호출해내고 있지만
      // build는 1.5 -> 1.0 일때만 호출되고 있기에 애니메이션이 끊어져서 표현되고 있었음
      // 여기에 setState를 추가하면 매 변경마다 build를 강제로 호출할 수 있게 됨
      setState(() {});
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChange(VisibilityInfo info) {
    //
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  //1.5 - pause -> 1.0  // 1.0 - play -> 1.5
  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse(); // reverse lowerbound to upperbound
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChange,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Transform.scale(
                  scale: _animationController.value,
                  child: AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: _isPaused ? 1 : 0,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size56,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
