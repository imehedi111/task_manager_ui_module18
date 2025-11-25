import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:task_management_project_module18/app.dart';
import 'package:task_management_project_module18/ui/controllers/authentication_controller.dart';
import 'package:task_management_project_module18/ui/screens/sign_in_screen.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest(String url) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url); //log request to see as dev....//
      Response response = await get(uri, headers: {
        'token' : AuthenticationController.accessToken ?? '',
      });
      _logResponse(url, response); //log response to see as dev....//

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          responseCode: response.statusCode,
          body: decodedData,
        );
      } else if (response.statusCode == 401){
        _onUnAthorize();
        return NetworkResponse(
          isSuccess: false,
          responseCode: response.statusCode,
          errorMessage: decodedData['Un-authorized'],
        );
      } else{
        return NetworkResponse(
          isSuccess: false,
          responseCode: response.statusCode,
          errorMessage: decodedData['data'],
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest(String url,
      {Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);

      _logRequest(url, body: body); //log request to see as dev....//
      Response response = await post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'token' : AuthenticationController.accessToken ?? '',
        },
        body: jsonEncode(body),
      );
      _logResponse(url, response); //log response to see as dev....//

      final decodedData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          responseCode: response.statusCode,
          body: decodedData,
        );
      } else if (response.statusCode == 401){
        _onUnAthorize();
        return NetworkResponse(
          isSuccess: false,
          responseCode: response.statusCode,
          errorMessage: decodedData['Un-authorized'],
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          responseCode: response.statusCode,
          errorMessage: decodedData['data'],
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        responseCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static void _onUnAthorize() async{
    await AuthenticationController.clearUserData();
    Navigator.pushNamed(TaskManagerApp.navigatorKey.currentContext!, SignInScreen.name);
  }

  //method for log request check............//
  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    debugPrint(
      'URL: $url\n'
      'Body: $body',
    );
  }

  //method log response check.............//
  static void _logResponse(String url, Response response) {
    debugPrint(
      'URL: $url\n'
      'Status Code: ${response.statusCode}\n'
      'Body: ${response.body}',
    );
  }
}

class NetworkResponse {
  final bool isSuccess;
  final int responseCode;
  final dynamic body;
  final String errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.responseCode,
    this.body,
    this.errorMessage = 'Something went wrong!',
  });
}
