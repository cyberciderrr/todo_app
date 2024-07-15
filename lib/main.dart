import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/service_locator.dart' as di;
import 'presentation/cubits/category_cubit.dart';
import 'presentation/cubits/task_cubit.dart'; // Import TaskCubit
import 'presentation/screens/category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CategoryCubit>()..loadCategories(),
        ),
        BlocProvider(
          create: (context) => di.sl<TaskCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'FEFU Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CategoryScreen(),
      ),
    );
  }
}
