import '../entities/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> removeTask(String id);
  Future<void> updateTask(Task task);
  Future<List<Task>> getTasksByCategory(String categoryId);
}
