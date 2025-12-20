import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/completed_task_list_provider.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import '../widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {

  @override
  void initState() {
    Future.microtask((){
      if(mounted){
        Provider.of<CompletedTaskListProvider>(context, listen: false).getCompletedTaskList();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Consumer<CompletedTaskListProvider>(
          builder: (context, completedTaskListProvider, _) {
            return Visibility(
              visible: completedTaskListProvider.getCompletedTaskListInProgress == false,
              replacement: center_circular_progress_indicator(),
              child: ListView.separated(
                itemCount: completedTaskListProvider.completedTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                      taskModel: completedTaskListProvider.completedTaskList[index],
                      refreshList: (){
                        completedTaskListProvider.getCompletedTaskList();
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
      ),
    );
  }
}
