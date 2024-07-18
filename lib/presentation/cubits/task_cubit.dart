import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/remove_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/get_tasks_by_category.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final AddTask addTaskUseCase;
  final RemoveTask removeTaskUseCase;
  final UpdateTask updateTaskUseCase;
  final GetTasksByCategory getTasksByCategoryUseCase;

  TaskCubit({
    required this.addTaskUseCase,
    required this.removeTaskUseCase,
    required this.updateTaskUseCase,
    required this.getTasksByCategoryUseCase,
  }) : super(TaskInitial());

  Future<void> loadTasks(String categoryId) async {
    try {
      emit(TaskLoading());
      final tasks = await getTasksByCategoryUseCase.call(categoryId);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
    }
  }

  Future<void> addTask(String title, String description, String categoryId, String? photoUrl) async {
    try {
      final task = Task(
        id: '',
        title: title,
        description: description,
        isCompleted: false,
        isFavourite: false,
        createdAt: DateTime.now(),
        categoryId: categoryId,
        photoUrl: photoUrl,
      );
      await addTaskUseCase.call(task);
      loadTasks(categoryId);
    } catch (e) {
      emit(TaskError('Failed to add task'));
    }
  }

  Future<void> removeTask(String id, String categoryId) async {
    try {
      await removeTaskUseCase.call(id);
      loadTasks(categoryId);
    } catch (e) {
      emit(TaskError('Failed to remove task'));
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      await updateTaskUseCase.call(updatedTask);
      loadTasks(updatedTask.categoryId);
    } catch (e) {
      emit(TaskError('Failed to update task'));
    }
  }

  Future<void> toggleTaskCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await updateTaskUseCase.call(updatedTask);
      loadTasks(task.categoryId);
    } catch (e) {
      emit(TaskError('Failed to toggle task completion'));
    }
  }

  Future<void> toggleTaskFavourite(Task task) async {
    try {
      final updatedTask = task.copyWith(isFavourite: !task.isFavourite);
      await updateTaskUseCase.call(updatedTask);
      loadTasks(task.categoryId);
    } catch (e) {
      emit(TaskError('Failed to toggle task favourite'));
    }
  }
}
