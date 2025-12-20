import 'package:flutter/cupertino.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class ProgressTaskListProvider extends ChangeNotifier {
  bool _getProgressTaskListInProgress = false;

  String? _errorMessage;

  List<TaskModel> _progressTaskList = [];

  bool get getProgressTaskListInProgress => _getProgressTaskListInProgress;

  List<TaskModel> get progressTaskList => _progressTaskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;

    _getProgressTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.progressTaskUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list.reversed.toList();

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProgressTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
