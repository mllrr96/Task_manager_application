import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/routes/app_router.dart';
import 'package:task_manager_app/bloc_state_observer.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/tasks/data/local/data_sources/tasks_data_provider.dart';
import 'package:task_manager_app/tasks/data/repository/task_repository.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/utils/constants.dart';
import 'package:task_manager_app/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocStateObserver();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp(preferences: preferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;

  const MyApp({super.key, required this.preferences});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          TaskRepository(taskDataProvider: TaskDataProvider(preferences)),
      child: BlocProvider(
        create: (context) => TasksBloc(context.read<TaskRepository>()),
        child: MaterialApp(
            title: Constants.appName,
            debugShowCheckedModeBanner: false,
            initialRoute: Pages.initial,
            onGenerateRoute: onGenerateRoute,
            themeMode: ThemeMode.system,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark),
      ),
    );
  }
}
