import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_project_module18/ui/providers/add_new_task_provider.dart';
import 'package:task_management_project_module18/ui/widgets/screen_background.dart';
import 'package:task_management_project_module18/ui/widgets/snack_bar_message.dart';
import 'package:task_management_project_module18/ui/widgets/tm_custom-appbar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = '/add-new-task';

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddNewTaskProvider _addNewTaskProvider = AddNewTaskProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _addNewTaskProvider,
      child: Scaffold(
        appBar: TMCustomAppBar(),
        body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    SizedBox(height: 15),
                    Text('Add New Task', style: TextTheme.of(context).titleLarge),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(hintText: 'Subject'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 8,
                      decoration: InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your Description';
                        }
                        return null;
                      },
                    ),
                    Consumer<AddNewTaskProvider>(
                      builder: (context, addNewTaskProvider, _) {
                        return Visibility(
                          visible:
                              addNewTaskProvider.addingNewTaskInProgress == false,
                          replacement: Center(
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                          child: FilledButton(
                            onPressed: _onTapSubmitButton,
                            child: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    final bool isSuccess = await _addNewTaskProvider.addNewTask(
      _titleController.text.trim(),
      _descriptionController.text.trim(),
    );

    if (isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'New Task Added!');

      Navigator.pop(context, true);
    } else {
      showSnackBarMessage(context, _addNewTaskProvider.errorMessage!);
    }
  }

  void _clearTextFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
