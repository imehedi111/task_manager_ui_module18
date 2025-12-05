import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/screens/otp_verify_screen.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

import '../../data/urls/urls.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  static const String name = '/set-new-password';

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  late String email;
  late String otp;

  bool _changingPassInProgress = false;

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    email = args["email"];
    otp = args["otp"];

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
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                  decoration: InputDecoration(hintText: 'Password'),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter New password';
                  }
                  if (value!.length < 7) {
                    return 'Password Should be minimum 7 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPassController,
                decoration: InputDecoration(hintText: 'Confirm Password'),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return 'Enter Confirm New password';
                  }
                  if (value!.length < 7) {
                    return 'Password Should be minimum 7 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              Visibility(
                visible: _changingPassInProgress == false,
                replacement: center_circular_progress_indicator(),
                child: FilledButton(
                  onPressed: _onTapConfirmButton,
                  child: Text('Confirm'),
                ),
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
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
      (predicate) => false,
    );
  }

  Future<void> _onTapConfirmButton() async {
    final String newPass = _newPasswordController.text;
    final String confirmPass = _confirmPassController.text;

    if(newPass.length < 7){
      showSnackBarMessage(context, "Password Should be minimum 7 characters");
      return;
    }
    if(newPass != confirmPass){
      showSnackBarMessage(context, "Password Do not match");
    }

    _changingPassInProgress = true;
    setState(() {});

    final Map<String, dynamic> body = {
      "email": email,
      "OTP": otp,
      "password": confirmPass,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.recoverResetPassUrl,
      body: body,
    );

    if(response.isSuccess){
      showSnackBarMessage(context, "Password changed successfully");

      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate) => false);

    }else{
      showSnackBarMessage(context, response.errorMessage);
    }

    _changingPassInProgress = false;
    setState(() {});
  }
}

