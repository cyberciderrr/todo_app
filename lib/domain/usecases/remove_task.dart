import '../entities/task.dart';
import '../repositories/task_repository.dart';
import 'usecase.dart';

class RemoveTask implements UseCase<void, Task> {
  final TaskRepository repository;

  RemoveTask(this.repository);

  @override
  Future<void> call(Task task) async {
    final tasks = await repository.getTasks(task.categoryId);
    tasks.removeWhere((item) => item.id == task.id);
    await repository.saveTasks(task.categoryId, tasks);
  }
}