import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/set_new_password_provider.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';


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

  final SetNewPasswordProvider _setNewPasswordProvider = SetNewPasswordProvider();

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    email = args["email"];
    otp = args["otp"];

    return ChangeNotifierProvider(
      create: (_) => _setNewPasswordProvider,
      child: Scaffold(
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
                Consumer<SetNewPasswordProvider>(
                  builder: (context, setNewPasswordProvider, _) {
                    return Visibility(
                      visible: setNewPasswordProvider.setNewPasswordInProgress == false,
                      replacement: center_circular_progress_indicator(),
                      child: FilledButton(
                        onPressed: _onTapConfirmButton,
                        child: Text('Confirm'),
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

    final bool isSuccess = await _setNewPasswordProvider.setNewPassword(
        email: email,
        otp: otp,
        newPassword: confirmPass,
    );

    if(isSuccess){
      showSnackBarMessage(context, "Password changed successfully");

      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.name, (predicate) => false);

    }else{
      showSnackBarMessage(context, _setNewPasswordProvider.errorMessage!);
    }

  }
}

