import 'package:flutter/material.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/urls/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getProgressTaskListInProgress = false;

  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    _getProgressTaskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Visibility(
          visible: _getProgressTaskListInProgress == false,
          replacement: center_circular_progress_indicator(),
          child: ListView.separated(
            itemCount: _progressTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _progressTaskList[index],
                refreshList: () {
                  _getProgressTaskList();
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _getProgressTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.progressTaskUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list.reversed.toList();
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }
}
