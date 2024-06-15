part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {
  final String categoryId;

  const LoadTasks(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class AddTaskEvent extends TaskEvent {
  final Task task;

  const AddTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  const UpdateTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class RemoveTaskEvent extends TaskEvent {
  final Task task;

  const RemoveTaskEvent(this.task);

  @override
  List<Object> get props => [task];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;
  final String categoryId;

  const ToggleTaskCompletionEvent(this.taskId, this.categoryId);

  @override
  List<Object> get props => [taskId, categoryId];
}

class ToggleTaskFavouriteEvent extends TaskEvent {
  final String taskId;
  final String categoryId;

  const ToggleTaskFavouriteEvent(this.taskId, this.categoryId);

  @override
  List<Object> get props => [taskId, categoryId];
}
