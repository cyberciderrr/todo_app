import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasksByCategory {
  final TaskRepository repository;

  const GetTasksByCategory(this.repository);

  Future<List<Task>> call(String categoryId) {
    return repository.getTasksByCategory(categoryId);
  }
}
