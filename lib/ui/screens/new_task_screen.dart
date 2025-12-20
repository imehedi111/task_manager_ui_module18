import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/new_task_list_provider.dart';
import 'package:task_management_project_module18/ui/screens/add_new_task_screen.dart';
import '../providers/task_count_list_provider.dart';
import '../widgets/center_circuler_progress.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask((){
      if(mounted){
        Provider.of<TaskCountListProvider>(context, listen: false).getTaskCountList();
      }
    });
    Future.microtask((){
      if(mounted){
        Provider.of<NewTaskListProvider>(context, listen: false).getNewTaskList();
      }
    });
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
            Consumer<NewTaskListProvider>(
              builder: (context, newTaskListProvider, _) {
                return Visibility(
                  visible: newTaskListProvider.getNewTaskListInProgress == false,
                  replacement: SizedBox(
                    height: 300,
                    child: center_circular_progress_indicator(),
                  ),
                  child: ListView.separated(
                    itemCount: newTaskListProvider.newTaskList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskModel: newTaskListProvider.newTaskList[index],
                        refreshList: () {
                          newTaskListProvider.getNewTaskList();
                          Provider.of<TaskCountListProvider>(context, listen: false).getTaskCountList();
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 12);
                    },
                  ),
                );
              }
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
    Navigator.pushNamed(context, AddNewTaskScreen.name).then((value) {
      if (value == true) {
        Provider.of<NewTaskListProvider>(context, listen: false).getNewTaskList();
        Provider.of<TaskCountListProvider>(context, listen: false).getTaskCountList();
      }
    });
  }

  Widget _buildTaskCountStatusListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: SizedBox(
        height: 75,
        child: Consumer<TaskCountListProvider>(
          builder: (context, taskCountListProvider, _) {
            return Visibility(
              visible: taskCountListProvider.getTaskCountListInProgress == false,
              replacement: center_circular_progress_indicator(),
              child: ListView.builder(
                itemCount: taskCountListProvider.taskCountList.length,
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
                              taskCountListProvider.taskCountList[index].sum.toString(),
                              style: TextTheme.of(context).titleMedium,
                            ),
                            Text(
                              taskCountListProvider.taskCountList[index].id,
                              style: TextTheme.of(context).titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }
}
