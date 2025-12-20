import 'package:flutter/cupertino.dart';
import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';
import '../controllers/authentication_controller.dart';

class SignInProvider extends ChangeNotifier{
  bool _signingInProgress = false;

  String? _errorMessage;

  bool get signnginProgress => _signingInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;

    _signingInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.signInUrl,
      body: requestBody,
    );

    if(response.isSuccess){
      UserModel userModel = UserModel.fromJson(response.body['data']);
      String accessToken = response.body['token'];

      await AuthenticationController.saveUserData(accessToken, userModel);

      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _signingInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}