import 'package:flutter/material.dart';
import'../../models/task.dart';


class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onSave;
  final Function(Task) onDelete;

  TaskDetailScreen({required this.task, required this.onSave, required this.onDelete});

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
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: widget.task.isCompleted,
      isFavourite: widget.task.isFavourite,
      categoryId: widget.task.categoryId,
      id: widget.task.id,
      createdAt: widget.task.createdAt,
    );
    widget.onSave(updatedTask);
    Navigator.of(context).pop();
  }

  void _deleteTask() {
    widget.onDelete(widget.task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Редактировать задачу'),
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
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Описание',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _deleteTask,
                  icon: Icon(Icons.delete),
                  label: Text('Удалить'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton.icon(
                  onPressed: _saveTask,
                  icon: Icon(Icons.save),
                  label: Text('Сохранить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
