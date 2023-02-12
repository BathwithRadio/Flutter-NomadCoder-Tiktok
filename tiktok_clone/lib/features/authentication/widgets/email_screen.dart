import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  // Controller - allow us control widget from code, method
  final TextEditingController _usernameController = TextEditingController();

  String _userName = "";

  @override
  void initState() {
    //
    super.initState(); // state initialize - so this coma first
    _usernameController.addListener(() {
      setState(() {
        _userName = _usernameController.text;
      });
    });
  }

  // 반드시 dispose 할 것 - 하지 않으면 언젠가 앱이 메모리 부족으로 크래시남
  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose(); // after all - clean up - dispose at latest
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "What is your email",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v20,
            FormButton(disabled: _userName.isEmpty)
          ],
        ),
      ),
    );
  }
}
