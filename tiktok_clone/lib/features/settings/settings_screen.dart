import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: const [
          CircularProgressIndicator.adaptive(),
          // ListWheelScrollView(
          //   diameterRatio: 2,
          //   offAxisFraction: 1,
          //   itemExtent: 200,
          //   children: [
          //     for (var x in [1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 1, 11, 1])
          //       FractionallySizedBox(
          //         widthFactor: 1,
          //         child: Container(
          //           color: Colors.teal,
          //           alignment: Alignment.center,
          //           child: const Text(
          //             "Pick me",
          //             style: TextStyle(color: Colors.white, fontSize: 39),
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
