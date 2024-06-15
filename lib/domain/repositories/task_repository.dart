import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks(String categoryId);
  Future<void> saveTasks(String categoryId, List<Task> tasks);
}
