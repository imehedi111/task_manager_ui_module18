import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/forgot_password_provider.dart';
import 'package:task_management_project_module18/ui/screens/otp_verify_screen.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const String name = '/forgot-password';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ForgotPasswordProvider _forgotPasswordProvider = ForgotPasswordProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _forgotPasswordProvider,
      child: Scaffold(
        body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'A 6 digit verification OTP/Pin will send to your email address',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                      decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value){
                      if(value == null || value.trim().isEmpty){
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  Consumer<ForgotPasswordProvider>(
                    builder: (context, forgotPasswordProvider, _) {
                      return Visibility(
                        visible: forgotPasswordProvider.sendingOtpInProgress == false,
                        replacement: center_circular_progress_indicator(),
                        child: FilledButton(
                          onPressed: _onTapOtpVerifyButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
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
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _onTapOtpVerifyButton() {
    if(_formKey.currentState!.validate()){
      _sendOtpToEmail();
    }
  }

  Future<void> _sendOtpToEmail() async{

    final String email = _emailController.text.trim();

    final bool isSuccess = await _forgotPasswordProvider.sendOtp(email);

    if(isSuccess){
      showSnackBarMessage(context, "A 6 digit OTP code sent to your email");
      Navigator.pushNamed(context, OtpVerifyScreen.name, arguments: email);
    }else{
      showSnackBarMessage(context, _forgotPasswordProvider.errorMessage!);
    }
  }

}
