import 'package:flutter/material.dart';
import '../data/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title, String description, String categoryId) {
    _tasks.add(Task(title: title, description: description, categoryId: categoryId, id: ''));
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    var taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  List<Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }
}
