import '../repositories/task_repository.dart';

class RemoveTask {
  final TaskRepository repository;

  const RemoveTask(this.repository);

  Future<void> call(String id) {
    return repository.removeTask(id);
  }
}
