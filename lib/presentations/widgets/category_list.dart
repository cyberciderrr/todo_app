import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../screens/task_screen.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    BlocProvider.of<CategoryBloc>(context).add(RemoveCategoryEvent(category));
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: BlocProvider.of<TaskBloc>(context),
                        child: TaskScreen(
                          categoryId: category.id,
                          categoryName: category.name,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (state is CategoryError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
