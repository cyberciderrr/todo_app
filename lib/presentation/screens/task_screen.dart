import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/task_cubit.dart';
import 'task_detail_screen.dart';
import '../../core/service_locator.dart';

class TaskScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const TaskScreen({required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskCubit>(
      create: (context) => sl<TaskCubit>()..loadTasks(categoryId),
      child: Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
        ),
        body: TaskView(categoryId: categoryId),
      ),
    );
  }
}

class TaskView extends StatelessWidget {
  final String categoryId;

  const TaskView({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                return ListView.builder(
                  itemCount: state.tasks.length,
                  itemBuilder: (context, index) {
                    final task = state.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          context.read<TaskCubit>().toggleTaskCompletion(task);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(task.isFavourite ? Icons.star : Icons.star_border),
                            onPressed: () {
                              context.read<TaskCubit>().toggleTaskFavourite(task);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailScreen(
                                    task: task,
                                    onSave: (updatedTask) {
                                      context.read<TaskCubit>().updateTask(updatedTask);
                                    },
                                    onDelete: (deletedTask) {
                                      context.read<TaskCubit>().removeTask(deletedTask.id, categoryId);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (state is TaskError) {
                return Center(child: Text(state.message));
              }
              return Container();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddTaskDialog(categoryId: categoryId);
                },
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final String categoryId;

  const AddTaskDialog({required this.categoryId});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController photoUrlController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    photoUrlController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    photoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить задачу'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Название задачи'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Описание задачи'),
          ),
          TextField(
            controller: photoUrlController, // Поле для ввода URL фото
            decoration: InputDecoration(hintText: 'URL фотографии'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
              context.read<TaskCubit>().addTask(
                titleController.text,
                descriptionController.text,
                widget.categoryId,
                photoUrlController.text.isNotEmpty ? photoUrlController.text : null,
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Введите название и описание задачи')),
              );
            }
          },
          child: Text('Добавить'),
        ),
      ],
    );
  }
}
