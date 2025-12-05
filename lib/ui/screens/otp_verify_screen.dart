import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/screens/set_new_password.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

import '../../data/urls/urls.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  static const String name = '/otp-verify';

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();

  late String email;

  bool _verifyOtpInProgress = false;

  @override
  Widget build(BuildContext context) {
    email = ModalRoute.of(context)!.settings.arguments as String;

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
                'OTP Verification',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'A 6 digit verification OTP/Pin has been send to your email address',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 8),

              /// new package pin code applied here
              ///
              PinCodeTextField(
                controller: _otpController,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                appContext: context,
              ),

              ///
              ///
              SizedBox(height: 8),
              Visibility(
                visible: _verifyOtpInProgress == false,
                replacement: center_circular_progress_indicator(),
                child: FilledButton(
                  onPressed: _onTapOtpVerifyButton,
                  child: Text('Verify'),
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

  void _onTapOtpVerifyButton() {
    _onTapOtpVerify();
  }

  Future<void> _onTapOtpVerify() async {
    String otp = _otpController.text.trim();

    if (otp.length < 6) {
      showSnackBarMessage(context, "Enter a 6 digit OTP code");
      return;
    }

    _verifyOtpInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.recoverVerifyOtpUrl(email, otp),
    );

    _verifyOtpInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      showSnackBarMessage(context, "OTP verified successfully");

      Navigator.pushNamed(
        context,
        SetNewPassword.name,
        arguments: {"email": email, "otp": otp},
      );
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
