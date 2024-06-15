import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../../core/exceptions.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks(String categoryId);
  Future<void> saveTasks(String categoryId, List<TaskModel> tasks);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getTasks(String categoryId) async {
    try {
      final String? tasksJson = sharedPreferences.getString('tasks_$categoryId');
      if (tasksJson != null) {
        final List<dynamic> tasksList = jsonDecode(tasksJson);
        final tasks = tasksList.map((json) => TaskModel.fromJson(json)).toList();
        print('Loaded tasks: $tasks');
        return tasks;
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading tasks: $e');
      throw CacheException();
    }
  }

  @override
  Future<void> saveTasks(String categoryId, List<TaskModel> tasks) async {
    try {
      final String tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      print('Saving tasks: $tasksJson');
      await sharedPreferences.setString('tasks_$categoryId', tasksJson);
    } catch (e) {
      print('Error saving tasks: $e');
      throw CacheException();
    }
  }
}
