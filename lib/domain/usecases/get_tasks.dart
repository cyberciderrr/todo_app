import '../entities/task.dart';
import '../repositories/task_repository.dart';
import 'usecase.dart';

class GetTasks implements UseCase<List<Task>, String> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Future<List<Task>> call(String categoryId) async {
    return await repository.getTasks(categoryId);
  }
}