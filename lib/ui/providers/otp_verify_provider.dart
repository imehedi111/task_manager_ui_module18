import 'package:flutter/cupertino.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class OtpVerifyProvider extends ChangeNotifier {
  bool _otpVerifyInProgress = false;

  String? _errorMessage;

  bool get otpVerifyInProgress => _otpVerifyInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> otpVerify({
    required String email,
    required String otp,
  }) async {
    bool isSuccess = false;

    _otpVerifyInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.recoverVerifyOtpUrl(email, otp),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _otpVerifyInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
