import 'package:flutter/material.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';
import '../../data/urls/urls.dart';
import '../widgets/task_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {

  bool _getCancelledTaskListInProgress = false;

  List<TaskModel> _cancelledTaskList = [];

  @override
  void initState() {
    _getCancelledTaskList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Visibility(
          visible: _getCancelledTaskListInProgress == false,
          replacement: center_circular_progress_indicator(),
          child: ListView.separated(
            itemCount: _cancelledTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                  taskModel: _cancelledTaskList[index],
                  refreshList: () {
                    _getCancelledTaskList();
                  },);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getCancelledTaskList()async{
    _getCancelledTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.cancelledTaskUrl,
    );

    if(response.isSuccess){
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }

    _getCancelledTaskListInProgress = false;
    setState(() {});

  }
}
