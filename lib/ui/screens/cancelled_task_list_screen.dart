import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';
import '../../data/urls/urls.dart';
import '../providers/cancelled_task_list_provider.dart';
import '../widgets/task_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {

  @override
  void initState() {
    Future.microtask((){
      if(mounted){
        Provider.of<CancelledTaskListProvider>(context, listen: false).getCancelledTaskList();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: Consumer<CancelledTaskListProvider>(
          builder: (context, cancelledTaskListProvider, _) {
            return Visibility(
              visible: cancelledTaskListProvider.getCancelledTaskListInProgress == false,
              replacement: center_circular_progress_indicator(),
              child: ListView.separated(
                itemCount: cancelledTaskListProvider.cancelledTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                      taskModel: cancelledTaskListProvider.cancelledTaskList[index],
                      refreshList: () {
                        cancelledTaskListProvider.getCancelledTaskList();
                      },);
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
