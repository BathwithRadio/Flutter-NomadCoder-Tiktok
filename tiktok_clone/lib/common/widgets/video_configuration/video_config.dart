import 'package:flutter/material.dart';

class VideoConfig extends ChangeNotifier {
  bool autoMute = false;

  void toggleAutoMute() {
    autoMute = !autoMute;
    // notify to listener there is data change
    notifyListeners();
  }
}

final videoConfig = VideoConfig();
