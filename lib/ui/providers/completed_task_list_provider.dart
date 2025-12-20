import 'package:flutter/cupertino.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class CompletedTaskListProvider extends ChangeNotifier {
  bool _getCompletedTaskListInProgress = false;

  String? _errorMessage;

  List<TaskModel> _completedTaskList = [];

  bool get getCompletedTaskListInProgress => _getCompletedTaskListInProgress;

  List<TaskModel> get completedTaskList => _completedTaskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;

    _getCompletedTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
        Urls.completedTaskUrl
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list.reversed.toList();

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCompletedTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
