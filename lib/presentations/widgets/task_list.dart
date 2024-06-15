import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../../domain/entities/task.dart';
import '../screens/task_detail_screen.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return Center(child: Text('No tasks available'));
          }
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return Card(
                color: task.isCompleted ? Colors.grey[200] : Colors.white,
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      context.read<TaskBloc>().add(ToggleTaskCompletionEvent(task.id, task.categoryId));
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(task.isFavourite ? Icons.star : Icons.star_border),
                        onPressed: () {
                          context.read<TaskBloc>().add(ToggleTaskFavouriteEvent(task.id, task.categoryId));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<TaskBloc>(context),
                              child: TaskDetailScreen(task: task),
                            ),
                          ));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<TaskBloc>().add(RemoveTaskEvent(task));
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<TaskBloc>(context),
                        child: TaskDetailScreen(task: task),
                      ),
                    ));
                  },
                ),
              );
            },
          );
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
