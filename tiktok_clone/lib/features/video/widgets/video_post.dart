import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/video_configuration/video_config.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/widgets/video_button.dart';
import 'package:tiktok_clone/features/video/widgets/video_comments.dart';
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
  late final VideoPlayerController _videoPlayerController;

  late final AnimationController _animationController;

  bool _isPaused = false;

  bool _seeMoreCheck = false;

  bool _isMuted = false;

  bool _autoMute = videoConfig.autoMute;

  final String _inputCaption = "This is Soondol!!! babababababababa so cute!!";

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
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/soondol.mp4");

    await _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    if (kIsWeb) {
      _muteButton(_isMuted);
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  void _muteButton(bool muteCheck) {
    if (muteCheck) {
      _videoPlayerController.setVolume(100);
    } else {
      _videoPlayerController.setVolume(0);
    }
  }

  void _checkMute() {
    setState(() {
      _isMuted = !_isMuted;
      _muteButton(_isMuted);
    });
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
    // _animationController.addListener(() {
    //   // print(_animationController.value);
    //   //-> _animationController는 1.0 1.1 1.2 ... 1.5까지를 호출해내고 있지만
    //   // build는 1.5 -> 1.0 일때만 호출되고 있기에 애니메이션이 끊어져서 표현되고 있었음
    //   // 여기에 setState를 추가하면 매 변경마다 build를 강제로 호출할 수 있게 됨
    //   setState(() {});
    // });

    videoConfig.addListener(() {
      setState(() {
        _autoMute = videoConfig.autoMute;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChange(VisibilityInfo info) {
    //
    // 한번 비디오를 정지하고 다른 화면으로 넘기고 자동 재생되기 전에 바로 다시 호출하면
    // 이미 dispose 된 상태에서 다시 호출하는 것이기 때문에 에러가 발생한다.
    // 그래서 mount를 호출함
    // mount - widget이 mount되었는지 아닌지 알려줌
    // mount되지 않으면 보여주지 않도록 하는것
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    // 동영상이 재생되고 있는 상태 && 화면에서 보이지 않게되면
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      // 멈춤
      _onTogglePause();
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

  void _onSeeMoreTap() {
    setState(() {
      _seeMoreCheck = !_seeMoreCheck;
    });
  }

  String _checkLongCaption() {
    return _inputCaption.length > 25
        ? "${_inputCaption.substring(0, 25)} ..."
        : _inputCaption;
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    // 내장 함수
    // 여기 await는 모달을 닫고나면 resolve된다.
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      // Bottomsheet의 화면 크기를 조정하려면 필요
      isScrollControlled: true,
      context: context,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  @override
  Widget build(BuildContext context) {
    // dependOnInheritedWidgetOfExactType : VideoConfig라는 타입의
    //InheritedWidget을 가져오라고 context에 명령 가능
    // => VideoPost가 VideoConfig애 context를 통해서 직접 접근 가능

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
                // setState로 매번 빌드하는것이 아니라
                // _animationController가 변경되는 것을 감지하고 우리가 리턴하는
                // 것을 리빌드하도록 한다
                // setState로 하던걸 위젯이 대신 하도록 하는것
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
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
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                _autoMute
                    ? FontAwesomeIcons.volumeHigh
                    : FontAwesomeIcons.volumeOff,
                color: Colors.white,
              ),
              onPressed: videoConfig.toggleAutoMute,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "@민기",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Row(
                  children: [
                    Text(
                      _seeMoreCheck ? _inputCaption : _checkLongCaption(),
                      style: const TextStyle(
                        fontSize: Sizes.size16,
                        color: Colors.white,
                      ),
                    ),
                    Gaps.h6,
                    GestureDetector(
                      onTap: _onSeeMoreTap,
                      child: Text(
                        _seeMoreCheck ? "Close" : "See more",
                        style: const TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _checkMute,
                  child: VideoButton(
                    icon: !_isMuted
                        ? FontAwesomeIcons.volumeXmark
                        : FontAwesomeIcons.volumeHigh,
                    text: "",
                  ),
                ),
                Gaps.v10,
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/86900125?v=4"),
                  child: Text("Alsrl"),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "2.9M",
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: "33K",
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
