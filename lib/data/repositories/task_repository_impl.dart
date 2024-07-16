import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../models/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTask(Task task) {
    return localDataSource.addTask(TaskModel(
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      id: task.id,
    ));
  }

  @override
  Future<void> removeTask(String id) {
    return localDataSource.removeTask(id);
  }

  @override
  Future<void> updateTask(Task task) {
    return localDataSource.updateTask(TaskModel(
      title: task.title,
      description: task.description,
      categoryId: task.categoryId,
      id: task.id,
      isCompleted: task.isCompleted,
      isFavourite: task.isFavourite,
      createdAt: task.createdAt,
    ));
  }

  @override
  Future<List<Task>> getTasksByCategory(String categoryId) async {
    final taskModels = await localDataSource.getTasksByCategory(categoryId);
    return taskModels.map((model) => Task(
      id: model.id,
      title: model.title,
      description: model.description,
      isCompleted: model.isCompleted,
      isFavourite: model.isFavourite,
      createdAt: model.createdAt,
      categoryId: model.categoryId,
    )).toList();
  }
}
