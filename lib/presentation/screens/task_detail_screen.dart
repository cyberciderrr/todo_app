import 'package:flutter/material.dart';
import 'photo_search_screen.dart';
import '../../domain/entities/task.dart';

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
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _photoUrl = widget.task.photoUrl;
  }

  void _saveTask() {
    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: widget.task.isCompleted,
      isFavourite: widget.task.isFavourite,
      createdAt: widget.task.createdAt,
      categoryId: widget.task.categoryId,
      photoUrl: _photoUrl,
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
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Created: ${widget.task.createdAt}'),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            _photoUrl != null
                ? Image.network(_photoUrl!)
                : Text('No photo attached'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _deleteTask,
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final selectedUrl = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoSearchScreen(
                          onPhotoSelected: (url) {
                            setState(() {
                              _photoUrl = url;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.photo),
                  label: Text('Attach Photo'),
                ),
                ElevatedButton.icon(
                  onPressed: _saveTask,
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
