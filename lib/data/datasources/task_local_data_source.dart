import 'package:drift/drift.dart';
import 'package:ToDoApp/data/database/database.dart';
import '../models/task.dart';

abstract class TaskLocalDataSource {
  Future<void> addTask(TaskModel task);
  Future<void> removeTask(String id);
  Future<void> updateTask(TaskModel task);
  Future<List<TaskModel>> getTasksByCategory(String categoryId);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final AppDatabase database;

  TaskLocalDataSourceImpl({required this.database});

  @override
  Future<void> addTask(TaskModel task) async {
    await database.insertTask(TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      isFavourite: Value(task.isFavourite),
      createdAt: Value(task.createdAt),
      categoryId: Value(task.categoryId),
      photoUrl: Value(task.photoUrl),
    ) as Task);
  }

  @override
  Future<void> removeTask(String id) async {
    await database.deleteTask(id);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await database.updateTask(TasksCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      isCompleted: Value(task.isCompleted),
      isFavourite: Value(task.isFavourite),
      createdAt: Value(task.createdAt),
      categoryId: Value(task.categoryId),
      photoUrl: Value(task.photoUrl),
    ) as Task);
  }

  @override
  Future<List<TaskModel>> getTasksByCategory(String categoryId) async {
    final tasks = await database.getTasksByCategory(categoryId);
    return tasks.map((t) => TaskModel(
      id: t.id,
      title: t.title,
      description: t.description,
      isCompleted: t.isCompleted,
      isFavourite: t.isFavourite,
      createdAt: t.createdAt,
      categoryId: t.categoryId,
      photoUrl: t.photoUrl,
    )).toList();
  }
}
