import '../../core/exceptions.dart';
import '../models/task.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks(String categoryId) async {
    try {
      final taskModels = await localDataSource.getTasks(categoryId);
      return taskModels.map((model) => Task(
        id: model.id,
        title: model.title,
        description: model.description,
        isCompleted: model.isCompleted,
        isFavourite: model.isFavourite,
        categoryId: model.categoryId,
        createdAt: model.createdAt,
      )).toList();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveTasks(String categoryId, List<Task> tasks) async {
    try {
      final taskModels = tasks.map((task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        isCompleted: task.isCompleted,
        isFavourite: task.isFavourite,
        categoryId: task.categoryId,
        createdAt: task.createdAt,
      )).toList();
      await localDataSource.saveTasks(categoryId, taskModels);
    } catch (e) {
      throw CacheException();
    }
  }
}
