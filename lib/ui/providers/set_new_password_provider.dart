import 'package:flutter/cupertino.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class SetNewPasswordProvider extends ChangeNotifier {
  bool _setNewPasswordInProgress = false;

  String? _errorMessage;

  bool get setNewPasswordInProgress => _setNewPasswordInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> setNewPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    bool isSuccess = false;

    _setNewPasswordInProgress = true;
    notifyListeners();

    final Map<String, dynamic> body = {
      "email": email,
      "OTP": otp,
      "password": newPassword,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.recoverResetPassUrl,
      body: body,
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _setNewPasswordInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
