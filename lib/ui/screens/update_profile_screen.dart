import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management_project_module18/data/models/user_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/controllers/authentication_controller.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';
import 'package:task_management_project_module18/ui/widgets/tm_custom-appbar.dart';

import '../../data/urls/urls.dart';
import '../widgets/photo_peaker.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTeController = TextEditingController();
  final TextEditingController _fastNameTeController = TextEditingController();
  final TextEditingController _lastNameTeController = TextEditingController();
  final TextEditingController _mobileTeController = TextEditingController();
  final TextEditingController _paswordTeController = TextEditingController();
  final TextEditingController _photoTeController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    final UserModel userModel = AuthenticationController.user!;
    _emailTeController.text = userModel.email;
    _fastNameTeController.text = userModel.firstName;
    _lastNameTeController.text = userModel.lastName;
    _mobileTeController.text = userModel.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMCustomAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Text(
                    'Update Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  //select photo section...//
                  GestureDetector(
                    onTap: _pickImage,
                    child: photo_peaker(pickedImage: _pickedImage),
                  ),
                  //photo peaker............//
                  TextFormField(
                    controller: _emailTeController,
                    enabled: false,
                    decoration: InputDecoration(hintText: 'Email'),
                  ),
                  TextFormField(
                    controller: _fastNameTeController,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter First Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameTeController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Last Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _mobileTeController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Valid Phone Number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _paswordTeController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      String password = value ?? '';
                      if (password.isNotEmpty && password.length < 7) {
                        return 'Enter a password at least 7 letters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: center_circular_progress_indicator(),
                    child: FilledButton(
                      onPressed: _onTapUpdateProfileButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
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

  Future<void> _pickImage() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }

  void _onTapUpdateProfileButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTeController.text,
      "firstName": _fastNameTeController.text.trim(),
      "lastName": _lastNameTeController.text.trim(),
      "mobile": _mobileTeController.text.trim(),
    };

    if (_paswordTeController.text.isNotEmpty) {
      requestBody['password'] = _paswordTeController.text;
    }

    if (_pickedImage != null) {
      //this image should be under 100kb in size....//
      Uint8List imageBytes = await _pickedImage!.readAsBytes();

      String base64Image = base64Encode(imageBytes);

      requestBody['photo'] = base64Image;
    }
    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.updateProfileUrl,
      body: requestBody,
    );

    _updateProfileInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      requestBody['_id'] = AuthenticationController.user!.id;
      await AuthenticationController.updateUserData(
        UserModel.fromJson(requestBody),
      );
      setState(() {

      });
      showSnackBarMessage(context, 'Profile information has been updated!');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
  }
}
