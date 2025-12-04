import 'package:flutter/material.dart';
import 'package:task_management_project_module18/data/models/task_model.dart';
import 'package:task_management_project_module18/data/service/network_caller.dart';
import 'package:task_management_project_module18/data/urls/urls.dart';
import 'package:task_management_project_module18/ui/widgets/center_circuler_progress.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.refreshList,
  });

  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _chacneStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white,
        title: Text(
          widget.taskModel.title,
          style: TextTheme.of(context).titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.description,
              style: TextTheme.of(
                context,
              ).bodyMedium?.copyWith(color: Colors.grey, fontSize: 15),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${widget.taskModel.createdDate}',
              style: TextTheme.of(context).bodySmall?.copyWith(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.taskModel.status,
                    style: TextTheme.of(
                      context,
                    ).labelSmall?.copyWith(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusColor(widget.taskModel.status),
                  labelPadding: EdgeInsetsGeometry.symmetric(
                    horizontal: 25,
                    vertical: 0,
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: _chacneStatusInProgress == false,
                  replacement: center_circular_progress_indicator(),
                  child: IconButton(
                    onPressed: () {
                      _showChangeStatusDialog();
                    },
                    icon: Icon(Icons.edit_note_sharp, color: Colors.green),
                  ),
                ),
                Visibility(
                  visible: _deleteTaskInProgress == false,
                  replacement: center_circular_progress_indicator(),
                  child: IconButton(
                    onPressed: _deleteTask,
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('New'),
                trailing: _isCurrentStatus('New') ? Icon(Icons.done) : null,
                onTap: () {
                  _onTapChangeTaskTitle('New');
                },
              ),

              ListTile(
                title: Text('Completed'),
                trailing: _isCurrentStatus('Completed')
                    ? Icon(Icons.done)
                    : null,
                onTap: () {
                  _onTapChangeTaskTitle('Completed');
                },
              ),

              ListTile(
                title: Text('Cancelled'),
                trailing: _isCurrentStatus('Cancelled')
                    ? Icon(Icons.done)
                    : null,
                onTap: () {
                  _onTapChangeTaskTitle('Cancelled');
                },
              ),

              ListTile(
                title: Text('Progress'),
                trailing: _isCurrentStatus('Progress')
                    ? Icon(Icons.done)
                    : null,
                onTap: () {
                  _onTapChangeTaskTitle('Progress');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTapChangeTaskTitle(String status) {
    if (_isCurrentStatus(status)) return;

    Navigator.pop(context);

    _changeStatus(status);
  }

  bool _isCurrentStatus(String status) {
    return widget.taskModel.status == status;
  }

  Future<void> _changeStatus(String status) async {
    _chacneStatusInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.changeTaskStatusUrl(widget.taskModel.id, status),
    );
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      _chacneStatusInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.deleteTaskUrl(widget.taskModel.id),
    );
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      _deleteTaskInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'New':
        return Colors.lightBlueAccent;
      case 'Progress':
        return Colors.pink;
      case 'Cancelled':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }
}
