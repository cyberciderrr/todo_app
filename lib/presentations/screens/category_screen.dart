import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/remove_category.dart';
import '../../domain/usecases/save_categories.dart';
import '../../domain/usecases/update_category.dart';
import '../blocs/category/category_bloc.dart';
import '../widgets/category_list.dart';
import 'task_screen.dart';

class CategoryScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Category Name'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      final newCategory = Category(
                        id: DateTime.now().toString(), // Generate a unique ID
                        name: _nameController.text,
                        createdAt: DateTime.now(),
                      );
                      BlocProvider.of<CategoryBloc>(context).add(AddCategoryEvent(newCategory));
                      _nameController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(child: CategoryList()),
        ],
      ),
    );
  }
}
