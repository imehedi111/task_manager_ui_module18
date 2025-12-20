import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/progress_task_list_provider.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import '../widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {

  @override
  void initState() {
    Future.microtask((){
      if(mounted){
        Provider.of<ProgressTaskListProvider>(context, listen: false).getProgressTaskList();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Consumer<ProgressTaskListProvider>(
          builder: (context, progressTaskListProvider, _) {
            return Visibility(
              visible: progressTaskListProvider.getProgressTaskListInProgress == false,
              replacement: center_circular_progress_indicator(),
              child: ListView.separated(
                itemCount: progressTaskListProvider.progressTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: progressTaskListProvider.progressTaskList[index],
                    refreshList: () {
                      progressTaskListProvider.getProgressTaskList();
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
