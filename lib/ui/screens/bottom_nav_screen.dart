import 'package:flutter/material.dart';
import 'package:task_management_project_module18/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_management_project_module18/ui/screens/completed-task_list-screen.dart';
import 'package:task_management_project_module18/ui/screens/new_task_screen.dart';
import 'package:task_management_project_module18/ui/screens/progress_task_list_screen.dart';
import '../widgets/tm_custom-appbar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  static const String name = '/bottom-nav-main';

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    NewTaskScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen(),
    ProgressTaskListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMCustomAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        backgroundColor: Colors.white,
        indicatorColor: Colors.green,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero),
        ),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.add_task_outlined),
            label: 'New Task',
          ),
          NavigationDestination(
            icon: Icon(Icons.file_download_done),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_presentation_rounded),
            label: 'Cancelled',
          ),
          NavigationDestination(
            icon: Icon(Icons.run_circle),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
