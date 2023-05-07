import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/video_configuration/video_config.dart';
import 'package:tiktok_clone/constants/breakpoint.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  TextAlign _setTextAlignByScreen(double width) {
    return width > Breakpoints.sm ? TextAlign.center : TextAlign.start;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Localizations.override(
      context: context,
      locale: const Locale("es"), // how to set locallization
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            // ChangeNotifier를 사용할 때 AnimatedBuilder를 사용
            // AnimatedBuilder는 애니매이션 뿐만 아니라 값 변경알림에도 사용됨
            // 이렇게 사용하면 딱 이 부분만 rebuild 된다 - 전체를 rebuild하지 않아도 됨
            AnimatedBuilder(
              animation: videoConfig,
              builder: (context, child) => SwitchListTile.adaptive(
                value: videoConfig.autoMute,
                onChanged: (value) {
                  videoConfig.toggleAutoMute();
                },
                title: Text(
                  "Auto Mute",
                  textAlign: _setTextAlignByScreen(width),
                ),
                subtitle: Text(
                  "Videos will be muted by default.",
                  textAlign: _setTextAlignByScreen(width),
                ),
              ),
            ),
            SwitchListTile.adaptive(
              value: _notifications,
              onChanged: _onNotificationsChanged,
              title: Text(
                "Enable notifications",
                textAlign: _setTextAlignByScreen(width),
              ),
              subtitle: Text(
                "Enable notifications subtitle",
                textAlign: _setTextAlignByScreen(width),
              ),
            ),
            CheckboxListTile(
              activeColor: Colors.black,
              value: _notifications,
              onChanged: _onNotificationsChanged,
              title: Text(
                "Enable notifications",
                textAlign: _setTextAlignByScreen(width),
              ),
            ),
            ListTile(
              onTap: () async {
                if (!mounted) return;
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                );
                if (!mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (!mounted) return;
                final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
              },
              title: Text(
                "What is your birthday?",
                textAlign: _setTextAlignByScreen(width),
              ),
            ),
            const AboutListTile(),
            ListTile(
              title: Text(
                "Logout (iOS)",
                textAlign: _setTextAlignByScreen(width),
              ),
              textColor: Colors.red,
              onTap: () => showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Please don't go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text(
                        "Yes",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Logout (Android)",
                textAlign: _setTextAlignByScreen(width),
              ),
              textColor: Colors.red,
              onTap: () => showCupertinoDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const FaIcon(FontAwesomeIcons.skull),
                  title: const Text("Are you sure?"),
                  content: const Text("Please don't go"),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const FaIcon(FontAwesomeIcons.whatsapp),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Yes",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text(
                "Logout (iOS / Bottom)",
                textAlign: _setTextAlignByScreen(width),
              ),
              textColor: Colors.red,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text("Are you sure?"),
                    message: const Text("Plese don't gooooooo"),
                    actions: [
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Not log out"),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => Navigator.of(context).pop(),
                        isDestructiveAction: true,
                        child: const Text(
                          "Yes plz",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
