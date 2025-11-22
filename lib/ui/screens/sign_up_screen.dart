import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/data/urls/urls.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTeController = TextEditingController();
  final TextEditingController _firstNameTeController = TextEditingController();
  final TextEditingController _lastNameTeController = TextEditingController();
  final TextEditingController _mobileTeController = TextEditingController();
  final TextEditingController _passTeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _signUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
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
                  SizedBox(height: 50),
                  Text(
                    'Join With Us',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black,
                    ),
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
                    controller: _firstNameTeController,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameTeController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _mobileTeController,
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your valid mobile number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passTeController,
                    obscureText: false,
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
                  Visibility(
                    visible: _signUpInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ),
                    child: FilledButton(
                      onPressed: _onTapSignUpButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
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
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _onTapSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    _signUpInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTeController.text.trim(),
      "firstName": _firstNameTeController.text.trim(),
      "lastName": _lastNameTeController.text.trim(),
      "mobile": _mobileTeController.text.trim(),
      "password": _passTeController.text,
    };

    NetworkResponse response = await NetworkCaller.postRequest(Urls.registrationUrl,
      body: requestBody,
    );

    _signUpInProgress = false;
    setState(() {});


    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'Registration successful! please sign in');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _clearTextFields(){
    _emailTeController.clear();
    _firstNameTeController.clear();
    _lastNameTeController.clear();
    _mobileTeController.clear();
    _passTeController.clear();
  }

  @override
  void dispose() {
    _emailTeController.dispose();
    _firstNameTeController.dispose();
    _lastNameTeController.dispose();
    _mobileTeController.dispose();
    _passTeController.dispose();
    super.dispose();
  }
}
