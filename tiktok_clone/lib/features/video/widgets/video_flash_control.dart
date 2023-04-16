import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoFlashControl extends StatelessWidget {
  final FlashMode videoFlashMode;
  final Future<void> Function(FlashMode flashMode) setFlashMode;
  final FlashMode receivedFlashSetting;
  final Icon receivedIcon;

  const VideoFlashControl({
    super.key,
    required this.videoFlashMode,
    required this.setFlashMode,
    required this.receivedFlashSetting,
    required this.receivedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: videoFlashMode == receivedFlashSetting
          ? Colors.amber.shade200
          : Colors.white,
      onPressed: () => setFlashMode(receivedFlashSetting),
      icon: receivedIcon,
    );
  }
}
