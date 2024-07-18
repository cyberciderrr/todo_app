import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database/database.dart';
import '../data/datasources/category_local_data_source.dart';
import '../data/datasources/task_local_data_source.dart';
import '../data/repositories/category_repository_impl.dart';
import '../data/repositories/task_repository_impl.dart';
import '../domain/repositories/category_repository.dart';
import '../domain/repositories/task_repository.dart';
import '../domain/usecases/add_category.dart';
import '../domain/usecases/add_task.dart';
import '../domain/usecases/get_all_categories.dart';
import '../domain/usecases/get_tasks_by_category.dart';
import '../domain/usecases/remove_category.dart';
import '../domain/usecases/remove_task.dart';
import '../domain/usecases/update_category.dart';
import '../domain/usecases/update_task.dart';
import '../presentation/cubits/category_cubit.dart';
import '../presentation/cubits/task_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());


  sl.registerLazySingleton<CategoryLocalDataSource>(
        () => CategoryLocalDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<TaskLocalDataSource>(
        () => TaskLocalDataSourceImpl(database: sl()),
  );


  sl.registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<TaskRepository>(
        () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => RemoveCategory(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => RemoveTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => GetTasksByCategory(sl()));

  // Cubits
  sl.registerFactory(
        () => CategoryCubit(
      addCategoryUseCase: sl(),
      removeCategoryUseCase: sl(),
      updateCategoryUseCase: sl(),
      getAllCategoriesUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => TaskCubit(
      addTaskUseCase: sl(),
      removeTaskUseCase: sl(),
      updateTaskUseCase: sl(),
      getTasksByCategoryUseCase: sl(),
    ),
  );

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
