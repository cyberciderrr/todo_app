import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../blocs/task/task_bloc.dart';
import '../widgets/task_list.dart';
import 'package:get_it/get_it.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/save_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/remove_task.dart';

class TaskScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  TaskScreen({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        getTasks: GetIt.instance<GetTasks>(),
        saveTask: GetIt.instance<SaveTask>(),
        addTask: GetIt.instance<AddTask>(),
        updateTask: GetIt.instance<UpdateTask>(),
        removeTask: GetIt.instance<RemoveTask>(),
      )..add(LoadTasks(categoryId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
        ),
        body: Column(
          children: [
            Expanded(child: TaskList()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  _showAddTaskDialog(context);
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Task Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(hintText: 'Task Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                  final newTask = Task(
                    id: DateTime.now().toString(), // Generate a unique ID
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isCompleted: false,
                    isFavourite: false,
                    categoryId: categoryId,
                    createdAt: DateTime.now(),
                  );
                  BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(newTask));
                  print('Adding task: ${newTask.title}');
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
