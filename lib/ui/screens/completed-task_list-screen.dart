import 'package:flutter/material.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';
import '../../data/urls/urls.dart';
import '../widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {

  bool _getCompletedTaskListInProgress = false;

  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    _getCompletedTaskList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Visibility(
          visible: _getCompletedTaskListInProgress == false,
          replacement: center_circular_progress_indicator(),
          child: ListView.separated(
            itemCount: _completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                  taskModel: _completedTaskList[index],
                  refreshList: (){
                    _getCompletedTaskList();
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

  Future<void> _getCompletedTaskList()async{
    _getCompletedTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
        Urls.completedTaskUrl
    );

    if(response.isSuccess){
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    }else{
      showSnackBarMessage(context, response.errorMessage);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }
}
