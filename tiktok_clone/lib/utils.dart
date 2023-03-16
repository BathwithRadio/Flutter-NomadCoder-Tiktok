import 'package:flutter/material.dart';

// 따로 설정된 색상을 다룰 때(하드 코딩된 것) MediaQuery를 사용하는 Function을 만들 것
bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;
