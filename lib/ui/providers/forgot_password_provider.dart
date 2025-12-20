import 'package:flutter/cupertino.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class ForgotPasswordProvider extends ChangeNotifier{
  bool _sendingOtpInProgress = false;

  String? _errorMessage;

  bool get sendingOtpInProgress => _sendingOtpInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> sendOtp(String email) async {
    bool isSuccess = false;

    _sendingOtpInProgress = true;
    notifyListeners();

    final response = await NetworkCaller.getRequest(
      Urls.recoverVerifyEmailUrl(email),
    );

    if(response.isSuccess){
      _errorMessage = null;
      isSuccess = true;
    }else{
      _errorMessage = response.errorMessage;
    }

    _sendingOtpInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}