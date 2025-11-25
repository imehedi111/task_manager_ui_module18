import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_project_module18/data/models/user_model.dart';

class AuthenticationController {
  static final String _tokenKey = 'token';
  static final String _userKey = 'user';

  static String? accessToken;
  static UserModel? user;

  static Future<void> saveUserData(String token, UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_tokenKey, token);
    await sharedPreferences.setString(_userKey, jsonEncode(userModel.toJson()));
    accessToken = token;
    user = userModel;
  }

  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_tokenKey);
    if (token != null) {
      accessToken = token;
      user = UserModel.fromJson(
        jsonDecode(sharedPreferences.getString(_userKey)!),
      );
    }
  }

  static Future<bool> isUserAlreadyLogedIn() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_tokenKey);
    return token != null;
  }

  static Future<void> clearUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();
  }
}
