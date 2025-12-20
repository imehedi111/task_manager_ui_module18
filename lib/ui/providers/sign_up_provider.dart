import 'package:flutter/cupertino.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class SignUpProvider extends ChangeNotifier {
  bool _signingUpInProgress = false;

  String? _errorMessage;

  bool get signingUpInProgress => _signingUpInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> signUp(
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      ) async {
    bool isSuccess = false;

    _signingUpInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.registrationUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _signingUpInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
