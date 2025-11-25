import 'package:flutter/material.dart';
import '../widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            // return TaskCard();
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 12);
          },
        ),
      ),
    );
  }
}
