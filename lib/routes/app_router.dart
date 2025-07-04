import 'package:flutter/material.dart';
import 'package:task_manager_app/page_not_found.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/splash_screen.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';
import 'package:task_manager_app/tasks/presentation/pages/add_update_task_screen.dart';
import 'package:task_manager_app/tasks/presentation/pages/tasks_screen.dart';

Route onGenerateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Pages.initial:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
    case Pages.home:
      return MaterialPageRoute(
        builder: (context) => const TasksScreen(),
      );
    case Pages.addUpdateTask:
      final args = routeSettings.arguments as TaskModel?;
      return MaterialPageRoute(
        builder: (context) => AddUpdateTaskScreen(task: args),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const PageNotFound(),
      );
  }
}
