import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/onboarding/interest_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  //Global Key - can access to state of Form/ can trigger method of Form

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTap() {
    // State를 이용해서 입력값을 추적하지 않아도 된다.
    // 또한 Container, state... 이런 번잡한 것이 필요가 없다
    if (_formKey.currentState != null) {
      // 폼에서 유효성 검사
      if (_formKey.currentState!.validate()) {
        // 유효성 검사가 된 것을 save -> 이 값이 아래에 onSaved에 콜백 호출
        _formKey.currentState!.save();

        // Navigator.of(context).push(
        // push 를 사용하면 로그인 후에도 로그인 화면으로 돌아올 수 있다.
        // 로그인 한 순간 이전의 기록들을 지워버리면 돌아올 수 없게된다.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const InterestsScreen(),
          ),
          (route) {
            // predication
            // route 는 지금까지 표시했던 모든 화면의 경로
            return false; // 유지할 것이냐 말 것이냐
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please write your email";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['email'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please write your password";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: const FormButton(disabled: false),
              ), //속성을 더 보내서 Log in 이 나오게 해보면 좋을듯
            ],
          ),
        ),
      ),
    );
  }
}
