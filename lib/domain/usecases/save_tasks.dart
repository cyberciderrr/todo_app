import '../entities/task.dart';
import '../repositories/task_repository.dart';
import 'usecase.dart';


class SaveTask implements UseCase<void, SaveTaskParams> {
  final TaskRepository repository;

  SaveTask(this.repository);

  @override
  Future<void> call(SaveTaskParams params) async {
    final tasks = await repository.getTasks(params.categoryId);
    final index = tasks.indexWhere((t) => t.id == params.task.id);
    if (index != -1) {
      tasks[index] = params.task;
    } else {
      tasks.add(params.task);
    }
    await repository.saveTasks(params.categoryId, tasks);
  }
}

class SaveTaskParams {
  final String categoryId;
  final Task task;

  SaveTaskParams({
    required this.categoryId,
    required this.task,
  });
}
