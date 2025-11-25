import 'package:flutter/material.dart';
import 'package:task_management_project_module18/ui/screens/add_new_task_screen.dart';
import 'package:task_management_project_module18/ui/screens/bottom_nav_screen.dart';
import 'package:task_management_project_module18/ui/screens/forgot_password_screen.dart';
import 'package:task_management_project_module18/ui/screens/otp_verify_screen.dart';
import 'package:task_management_project_module18/ui/screens/set_new_password.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';
import 'package:task_management_project_module18/ui/screens/sign_up_screen.dart';
import 'package:task_management_project_module18/ui/screens/splash_screen.dart';
import 'package:task_management_project_module18/ui/screens/update_profile_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.green.shade50,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            iconSize: 22,
          ),
        ),
        colorSchemeSeed: Colors.green[400],
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          hintStyle: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.black,
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'My Task Manager',
      routes: <String, WidgetBuilder>{
        SplashScreen.name : (_) => SplashScreen(),
        SignInScreen.name : (_) => SignInScreen(),
        SignUpScreen.name : (_) => SignUpScreen(),
        ForgotPasswordScreen.name : (_) => ForgotPasswordScreen(),
        OtpVerifyScreen.name : (_) => OtpVerifyScreen(),
        SetNewPassword.name : (_) => SetNewPassword(),
        BottomNavScreen.name : (_) => BottomNavScreen(),
        AddNewTaskScreen.name : (_) => AddNewTaskScreen(),
        UpdateProfileScreen.name : (_) => UpdateProfileScreen(),
      },
      initialRoute: SplashScreen.name,
    );
  }
}
