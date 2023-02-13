import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
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

  //Stateful widget은 context를 받는 것이 필요 없다.
  // inside of state, you can receive context when, whereever
  void _onNextTap() {
    //
    if (_userName.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
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
              "Create Username",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w800,
              ),
            ),
            Gaps.v8,
            const Text(
              "You can always change this later.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
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
            GestureDetector(
              //Stateful widget은 context를 받는 것이 필요 없다.
              onTap: _onNextTap,
              child: FormButton(
                disabled: _userName.isEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
