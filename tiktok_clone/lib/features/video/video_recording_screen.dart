import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/video_preview_screen.dart';
import 'package:tiktok_clone/features/video/widgets/video_flash_control.dart';

final List<dynamic> flashButtons = [
  {
    "flashMode": FlashMode.off,
    "icon": const Icon(Icons.flash_off_rounded),
  },
  {
    "flashMode": FlashMode.always,
    "icon": const Icon(Icons.flash_on_rounded),
  },
  {
    "flashMode": FlashMode.auto,
    "icon": const Icon(Icons.flash_auto_rounded),
  },
  {
    "flashMode": FlashMode.torch,
    "icon": const Icon(Icons.flashlight_on_rounded),
  },
];

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _permissionDenied = false;
  bool _isSelfieMode = false;

  late FlashMode _flashMode;
  late CameraController _cameraController;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    // only for iOS
    // 가끔 iOS로 녹화를 하면 비디오와 영샹의 싱크가 맞지 않는데 그것을 해결하는 기능
    await _cameraController.prepareForVideoRecording();

    _flashMode = _cameraController.value.flashMode;
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
    } else {
      _permissionDenied = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    // animation의 value가 바뀐 것을 알려줌 0.1, 0.2....
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    // animation이 끝난 것을 알려줌
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    //이미 녹화중인지 확인
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    // 녹화 중지 전 확인 - 녹화중인데 녹화를 중지하면 안되니까
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(video: video),
      ),
    );
  }

  @override
  void dispose() {
    // Video Preview로 이동한 후에 이 화면에서 사용한 리소스를 계속 사용하고 싶지 않으므로
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: _permissionDenied
            ? const CameraStatus(
                status: "Permission Denied\n Setting > App > Turn on Camera")
            : !_hasPermission || !_cameraController.value.isInitialized
                ? const CameraStatus(status: "Initializing.....")
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraPreview(_cameraController),
                      Positioned(
                        top: Sizes.size40,
                        right: Sizes.size20,
                        child: Column(
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: _toggleSelfieMode,
                              icon: const Icon(
                                Icons.cameraswitch,
                              ),
                            ),
                            for (var flashButton in flashButtons)
                              Row(
                                children: [
                                  Gaps.v10,
                                  VideoFlashControl(
                                    videoFlashMode: _flashMode,
                                    setFlashMode: _setFlashMode,
                                    receivedFlashSetting:
                                        flashButton["flashMode"],
                                    receivedIcon: flashButton["icon"],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: Sizes.size40,
                        child: GestureDetector(
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size14,
                                  height: Sizes.size80 + Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size6,
                                    value: _progressAnimationController.value,
                                  ),
                                ),
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class CameraStatus extends StatelessWidget {
  final String status;

  const CameraStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size20,
          ),
          textAlign: TextAlign.center,
        ),
        Gaps.v20,
        const CircularProgressIndicator.adaptive(),
      ],
    );
  }
}
