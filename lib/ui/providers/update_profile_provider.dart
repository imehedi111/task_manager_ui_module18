import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management_project_module18/data/models/user_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/data/urls/urls.dart';
import 'package:task_management_project_module18/ui/controllers/authentication_controller.dart';

class UpdateProfileProvider extends ChangeNotifier {
  bool _updateInProgress = false;
  String? _errorMessage;

  bool get updateInProgress => _updateInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    XFile? pickedImage,
  }) async {
    bool isSuccess = false;

    _updateInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password != null && password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (pickedImage != null) {
      Uint8List imageBytes = await pickedImage.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.updateProfileUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _errorMessage = null;

      requestBody['_id'] = AuthenticationController.user!.id;
      await AuthenticationController.updateUserData(
        UserModel.fromJson(requestBody),
      );

      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _updateInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
