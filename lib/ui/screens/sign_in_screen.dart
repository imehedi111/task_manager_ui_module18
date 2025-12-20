import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/sign_in_provider.dart';
import 'package:task_management_project_module18/ui/screens/bottom_nav_screen.dart';
import 'package:task_management_project_module18/ui/screens/forgot_password_screen.dart';
import 'package:task_management_project_module18/ui/screens/sign_up_screen.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTeController = TextEditingController();
  final TextEditingController _passTeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final SignInProvider _signInProvider = SignInProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _signInProvider,
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
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTeController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a valid email';
                      }
                      if (EmailValidator.validate(value!) == false) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passTeController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your correct password';
                      }
                      if (value!.length < 7) {
                        return 'Enter a password more than 6';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  Consumer<SignInProvider>(
                    builder: (context, signInProvider, _) {
                      return Visibility(
                        visible: signInProvider.signnginProgress == false,
                        replacement: Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                        child: FilledButton(
                          onPressed: _onTapSignInButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: Text('Forget Password?'),
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                            text: "Don't have account? ",
                            children: [
                              TextSpan(
                                style: TextStyle(color: Colors.green),
                                text: 'Sign up',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignUpButton,
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
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {

    final bool isSuccess = await _signInProvider.signIn(_emailTeController.text.trim(), _passTeController.text);

    if(isSuccess){
      Navigator.pushReplacementNamed(context, BottomNavScreen.name);
    }else{
      showSnackBarMessage(context, _signInProvider.errorMessage!);
    }
  }

  void _onTapForgotPasswordButton() {
    Navigator.pushNamed(context, ForgotPasswordScreen.name);
  }

  void _onTapSignUpButton() {
    Navigator.pushNamed(context, SignUpScreen.name);
  }
}
