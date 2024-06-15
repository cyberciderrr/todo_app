import '../entities/task.dart';
import '../repositories/task_repository.dart';
import 'usecase.dart';


class UpdateTask implements UseCase<void, Task> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<void> call(Task task) async {
    final tasks = await repository.getTasks(task.categoryId);
    final index = tasks.indexWhere((item) => item.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await repository.saveTasks(task.categoryId, tasks);
    }
  }
}
