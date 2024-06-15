import '../entities/task.dart';
import '../repositories/task_repository.dart';
import 'usecase.dart';

class AddTask implements UseCase<void, Task> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<void> call(Task task) async {
    final tasks = await repository.getTasks(task.categoryId);
    tasks.add(task);
    await repository.saveTasks(task.categoryId, tasks);
  }
}