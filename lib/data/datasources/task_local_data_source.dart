import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

abstract class TaskLocalDataSource {
  Future<void> addTask(TaskModel task);
  Future<void> removeTask(String id);
  Future<void> updateTask(TaskModel task);
  Future<List<TaskModel>> getTasksByCategory(String categoryId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> addTask(TaskModel task) async {
    final tasks = await getTasksByCategory(task.categoryId);
    tasks.add(task);
    await _saveTasks(task.categoryId, tasks);
  }

  @override
  Future<void> removeTask(String id) async {
    final tasks = await getTasksByCategory(id);
    tasks.removeWhere((task) => task.id == id);
    if (tasks.isNotEmpty) {
      await _saveTasks(tasks[0].categoryId, tasks);
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final tasks = await getTasksByCategory(task.categoryId);
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await _saveTasks(task.categoryId, tasks);
    }
  }

  @override
  Future<List<TaskModel>> getTasksByCategory(String categoryId) async {
    final jsonString = sharedPreferences.getString('tasks_$categoryId');
    if (jsonString != null) {
      final List decodedJson = jsonDecode(jsonString);
      return decodedJson.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> _saveTasks(String categoryId, List<TaskModel> tasks) async {
    final jsonString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await sharedPreferences.setString('tasks_$categoryId', jsonString);
  }
}
