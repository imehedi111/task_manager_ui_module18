import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project_module18/ui/screens/otp_verify_screen.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  static const String name = '/set-new-password';

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Set Password',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Minimum length password 8 character with Latter and number combination',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(decoration: InputDecoration(hintText: 'Password')),
              TextFormField(decoration: InputDecoration(hintText: 'Confirm Password')),
              SizedBox(height: 8),
              FilledButton(
                onPressed: _onTapConfirmButton,
                child: Text('Confirm'),
              ),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                        text: "Have account? ",
                        children: [
                          TextSpan(
                            style: TextStyle(color: Colors.green),
                            text: 'Sign in',
                            recognizer: TapGestureRecognizer()
                              ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate) => false);
  }

  void _onTapConfirmButton() {

  }

}
