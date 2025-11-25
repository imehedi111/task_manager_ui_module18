import 'package:flutter/material.dart';
import 'package:task_management_project_module18/data/models/task_count_model.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/screens/add_new_task_screen.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

import '../../data/urls/urls.dart';
import '../widgets/center_circuler_progress.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getNewTaskListInProgress = false;
  bool _getTaskCountInProgress = false;

  List<TaskModel> _newTaskList = [];
  List<TaskCountModel> _taskCountList = [];

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskCountList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildTaskCountStatusListView(),
            SizedBox(height: 10),
            Visibility(
              visible: _getNewTaskListInProgress == false,
              replacement: SizedBox(
                height: 300,
                child: center_circular_progress_indicator(),
              ),
              child: ListView.separated(
                itemCount: _newTaskList.length,
                primary: false,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskCard(taskModel: _newTaskList[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name).then((value){
      if(value == true){
        _getNewTaskList();
        _getTaskCountList();
      }
    });
  }

  Widget _buildTaskCountStatusListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: SizedBox(
        height: 75,
        child: Visibility(
          visible: _getTaskCountInProgress == false,
          replacement: center_circular_progress_indicator(),
          child: ListView.builder(
            itemCount: _taskCountList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          _taskCountList[index].sum.toString(),
                          style: TextTheme.of(context).titleMedium,
                        ),
                        Text(_taskCountList[index].id, style: TextTheme.of(context).titleSmall),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.newTaskUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list.reversed.toList();
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskListInProgress = false;
    setState(() {});
  }

  ///this bellow one is for count box of task status....///
  ///

  Future<void> _getTaskCountList() async {
    _getTaskCountInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.taskCountListUrl,
    );

    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.fromJson(jsonData));
      }
      _taskCountList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getTaskCountInProgress = false;
    setState(() {});
  }
}
