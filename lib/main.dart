import 'package:ToDoApp/presentations/blocs/category/category_bloc.dart';
import 'package:ToDoApp/presentations/blocs/task/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/task_local_data_source.dart';
import 'data/datasources/category_local_data_source.dart';
import 'data/repositories/task_repository_impl.dart';
import 'data/repositories/category_repository_impl.dart';
import 'domain/repositories/task_repository.dart';
import 'domain/repositories/category_repository.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/save_categories.dart';
import 'domain/usecases/get_categories.dart';
import 'domain/usecases/save_tasks.dart';
import 'domain/usecases/add_task.dart';
import 'domain/usecases/add_category.dart';
import 'domain/usecases/remove_task.dart';
import 'domain/usecases/remove_category.dart';
import 'domain/usecases/update_task.dart';
import 'domain/usecases/update_category.dart';
import 'presentations/screens/category_screen.dart';

void setupLocator() {
  GetIt.instance.registerSingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });

  GetIt.instance.registerSingletonWithDependencies<TaskLocalDataSource>(
        () => TaskLocalDataSourceImpl(sharedPreferences: GetIt.instance<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  GetIt.instance.registerSingletonWithDependencies<CategoryLocalDataSource>(
        () => CategoryLocalDataSourceImpl(sharedPreferences: GetIt.instance<SharedPreferences>()),
    dependsOn: [SharedPreferences],
  );

  GetIt.instance.registerFactory<TaskRepository>(() => TaskRepositoryImpl(
    localDataSource: GetIt.instance<TaskLocalDataSource>(),
  ));

  GetIt.instance.registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(
    localDataSource: GetIt.instance<CategoryLocalDataSource>(),
  ));

  GetIt.instance.registerFactory(() => GetTasks(GetIt.instance<TaskRepository>()));
  GetIt.instance.registerFactory(() => SaveTask(GetIt.instance<TaskRepository>()));
  GetIt.instance.registerFactory(() => GetCategories(GetIt.instance<CategoryRepository>()));
  GetIt.instance.registerFactory(() => SaveCategory(GetIt.instance<CategoryRepository>()));
  GetIt.instance.registerFactory(() => AddTask(GetIt.instance<TaskRepository>()));
  GetIt.instance.registerFactory(() => AddCategory(GetIt.instance<CategoryRepository>()));
  GetIt.instance.registerFactory(() => RemoveTask(GetIt.instance<TaskRepository>()));
  GetIt.instance.registerFactory(() => RemoveCategory(GetIt.instance<CategoryRepository>()));
  GetIt.instance.registerFactory(() => UpdateTask(GetIt.instance<TaskRepository>()));
  GetIt.instance.registerFactory(() => UpdateCategory(GetIt.instance<CategoryRepository>()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await GetIt.instance.allReady();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(
            getCategoriesUseCase: GetIt.instance<GetCategories>(),
            saveCategoryUseCase: GetIt.instance<SaveCategory>(),
            addCategoryUseCase: GetIt.instance<AddCategory>(),
            updateCategoryUseCase: GetIt.instance<UpdateCategory>(),
            removeCategoryUseCase: GetIt.instance<RemoveCategory>(),
          )..add(LoadCategories()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(
            getTasks: GetIt.instance<GetTasks>(),
            saveTask: GetIt.instance<SaveTask>(),
            addTask: GetIt.instance<AddTask>(),
            updateTask: GetIt.instance<UpdateTask>(),
            removeTask: GetIt.instance<RemoveTask>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Clean Architecture',
        home: CategoryScreen(),
      ),
    );
  }
}
