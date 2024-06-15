import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  void _saveTask() {
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: widget.task.isCompleted,
      isFavourite: widget.task.isFavourite,
      categoryId: widget.task.categoryId,
      createdAt: widget.task.createdAt,
    );
    BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(updatedTask));
    Navigator.of(context).pop();
  }

  void _deleteTask() {
    BlocProvider.of<TaskBloc>(context).add(RemoveTaskEvent(widget.task));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать задачу'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Создана: ${widget.task.createdAt}'),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Заголовок',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _deleteTask,
              icon: Icon(Icons.delete),
              label: Text('Удалить'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
