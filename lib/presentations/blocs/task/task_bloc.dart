import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/usecases/get_tasks.dart';
import '../../../domain/usecases/save_tasks.dart';
import '../../../domain/usecases/add_task.dart';
import '../../../domain/usecases/update_task.dart';
import '../../../domain/usecases/remove_task.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final SaveTask saveTask;
  final AddTask addTask;
  final UpdateTask updateTask;
  final RemoveTask removeTask;

  TaskBloc({
    required this.getTasks,
    required this.saveTask,
    required this.addTask,
    required this.updateTask,
    required this.removeTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<RemoveTaskEvent>(_onRemoveTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<ToggleTaskFavouriteEvent>(_onToggleTaskFavourite);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      emit(TaskLoading());
      final tasks = await getTasks(event.categoryId);
      emit(TaskLoaded(tasks));
      print('Tasks loaded: ${tasks.length}');
    } catch (e) {
      emit(TaskError('Failed to load tasks'));
      print('Error loading tasks: $e');
    }
  }

  Future<void> _onAddTask(AddTaskEvent event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final updatedTasks = List<Task>.from((state as TaskLoaded).tasks)..add(event.task);
        emit(TaskLoaded(updatedTasks)); // Emit the updated state immediately
        print('State after adding task: ${updatedTasks.length} tasks');
        await saveTask(SaveTaskParams(categoryId: event.task.categoryId, task: event.task));
        print('Task added successfully: ${event.task.title}');
      } else {
        await _onLoadTasks(LoadTasks(event.task.categoryId), emit);
        add(event);  // Retry adding the task after loading
      }
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
      print('Error adding task: $e');
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final updatedTasks = (state as TaskLoaded).tasks.map((task) {
          return task.id == event.task.id ? event.task : task;
        }).toList();
        emit(TaskLoaded(updatedTasks));
        await saveTask(SaveTaskParams(categoryId: event.task.categoryId, task: event.task));
      }
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> _onRemoveTask(RemoveTaskEvent event, Emitter<TaskState> emit) async {
    try {
      if (state is TaskLoaded) {
        final updatedTasks = (state as TaskLoaded).tasks.where((task) => task.id != event.task.id).toList();
        emit(TaskLoaded(updatedTasks));
        await saveTask(SaveTaskParams(categoryId: event.task.categoryId, task: event.task));
      }
    } catch (e) {
      emit(TaskError('Failed to remove task: $e'));
    }
  }

  Future<void> _onToggleTaskCompletion(ToggleTaskCompletionEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = (state as TaskLoaded).tasks.map((task) {
        return task.id == event.taskId ? task.copyWith(isCompleted: !task.isCompleted) : task;
      }).toList();
      final task = updatedTasks.firstWhere((task) => task.id == event.taskId);
      emit(TaskLoaded(updatedTasks));
      await saveTask(SaveTaskParams(categoryId: event.categoryId, task: task));
    }
  }

  Future<void> _onToggleTaskFavourite(ToggleTaskFavouriteEvent event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      final updatedTasks = (state as TaskLoaded).tasks.map((task) {
        return task.id == event.taskId ? task.copyWith(isFavourite: !task.isFavourite) : task;
      }).toList();
      final task = updatedTasks.firstWhere((task) => task.id == event.taskId);
      emit(TaskLoaded(updatedTasks));
      await saveTask(SaveTaskParams(categoryId: event.categoryId, task: task));
    }
  }
}
