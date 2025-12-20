import 'package:flutter/cupertino.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';

class CancelledTaskListProvider extends ChangeNotifier {
  bool _getCancelledTaskListInProgress = false;

  String? _errorMessage;

  List<TaskModel> _cancelledTaskList = [];

  bool get getCancelledTaskListInProgress => _getCancelledTaskListInProgress;

  List<TaskModel> get cancelledTaskList => _cancelledTaskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;

    _getCancelledTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.cancelledTaskUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list.reversed.toList();

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCancelledTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
