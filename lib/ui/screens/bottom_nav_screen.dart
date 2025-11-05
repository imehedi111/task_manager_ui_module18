import 'package:flutter/material.dart';
import '../widgets/tm_custom-appbar.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  static const String name = '/bottom-nav-main';

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMCustomAppBar(),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.green,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index){
            _selectedIndex = index;
            setState(() { });
          },
          destinations: [
        NavigationDestination(icon: Icon(Icons.add_task_outlined), label: 'New Task'),
        NavigationDestination(icon: Icon(Icons.file_download_done), label: 'Completed'),
        NavigationDestination(icon: Icon(Icons.cancel_presentation_rounded), label: 'Cancelled'),
        NavigationDestination(icon: Icon(Icons.run_circle), label: 'Progress'),
      ]),
    );
  }
}
