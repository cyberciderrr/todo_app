import 'package:flutter/material.dart';
import '../../models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task_detail_screen.dart';

class TaskScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  TaskScreen({required this.categoryId, required this.categoryName});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  String filter = 'Все';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks_${widget.categoryId}');
      if (tasksJson != null) {
        final List<dynamic> tasksList = jsonDecode(tasksJson);
        setState(() {
          tasks = tasksList.map((json) => Task.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print('Failed to load tasks: $e');
      _showErrorSnackBar('Не удалось загрузить задачи');
    }
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  void _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      prefs.setString('tasks_${widget.categoryId}', tasksJson);
    } catch (e) {
      print('Failed to save tasks: $e');
      _showErrorSnackBar('Не удалось сохранить задачи');
    }
  }

  void _addTask(String title, String description) {
    setState(() {
      tasks.add(Task(title: title, description: description, categoryId: widget.categoryId));
      _saveTasks();
    });
  }

  void _deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
      _saveTasks();
    });
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      final index = tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
        _saveTasks();
      }
    });
  }

  void _toggleTaskCompletion(String id) {
    setState(() {
      final index = tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        tasks[index] = Task(
          title: tasks[index].title,
          description: tasks[index].description,
          isCompleted: !tasks[index].isCompleted,
          isFavourite: tasks[index].isFavourite,
          categoryId: tasks[index].categoryId,
          id: tasks[index].id,
          createdAt: tasks[index].createdAt,
        );
        _saveTasks();
      }
    });
  }

  void _toggleTaskFavourite(String id) {
    setState(() {
      final index = tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        tasks[index] = Task(
          title: tasks[index].title,
          description: tasks[index].description,
          isCompleted: tasks[index].isCompleted,
          isFavourite: !tasks[index].isFavourite,
          categoryId: tasks[index].categoryId,
          id: tasks[index].id,
          createdAt: tasks[index].createdAt,
        );
        _saveTasks();
      }
    });
  }

  List<Task> get filteredTasks {
    switch (filter) {
      case 'Завершенные':
        return tasks.where((task) => task.isCompleted).toList();
      case 'Незавершенные':
        return tasks.where((task) => !task.isCompleted).toList();
      case 'Избранные':
        return tasks.where((task) => task.isFavourite).toList();
      default:
        return tasks;
    }
  }

  void _showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Название задачи'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(hintText: 'Описание задачи'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                _addTask(titleController.text, descriptionController.text);
                Navigator.of(context).pop();
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Все', child: Text('Все')),
              PopupMenuItem(value: 'Завершенные', child: Text('Завершенные')),
              PopupMenuItem(value: 'Незавершенные', child: Text('Незавершенные')),
              PopupMenuItem(value: 'Избранные', child: Text('Избранные')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  color: task.isCompleted ? Colors.grey[200] : Colors.white,
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description),
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        _toggleTaskCompletion(task.id);
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(task.isFavourite ? Icons.star : Icons.star_border),
                          onPressed: () => _toggleTaskFavourite(task.id),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(
                                  task: task,
                                  onSave: _updateTask,
                                  onDelete: _deleteTask,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _showAddTaskDialog,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
