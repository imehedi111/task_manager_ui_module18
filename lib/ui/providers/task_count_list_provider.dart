import 'package:flutter/cupertino.dart';
import '../../data/models/task_count_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class TaskCountListProvider extends ChangeNotifier {
  bool _getTaskCountInProgress = false;

  String? _errorMessage;

  List<TaskCountModel> _taskCountList = [];

  bool get getTaskCountListInProgress => _getTaskCountInProgress;

  List<TaskCountModel> get taskCountList => _taskCountList;

  String? get errorMessage => _errorMessage;

  Future<bool> getTaskCountList() async {
    bool isSuccess = false;

    _getTaskCountInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.taskCountListUrl,
    );

    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.fromJson(jsonData));
      }
      _taskCountList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getTaskCountInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
