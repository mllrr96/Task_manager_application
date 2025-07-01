import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:task_manager_app/components/custom_app_bar.dart';
import 'package:task_manager_app/components/custom_text_field.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/tasks/presentation/widget/task_item_view.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:task_manager_app/utils/scaffold_messenger_extension.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<TasksBloc>().add(FetchTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
      ),
      child: ScaffoldMessenger(
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Tasks',
            showBackArrow: false,
            actionWidgets: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: PopupMenuButton<int>(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 1,
                  icon: Icon(LucideIcons.list_filter_plus),
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        {
                          context
                              .read<TasksBloc>()
                              .add(SortTaskEvent(sortOption: 0));
                          break;
                        }
                      case 1:
                        {
                          context
                              .read<TasksBloc>()
                              .add(SortTaskEvent(sortOption: 1));
                          break;
                        }
                      case 2:
                        {
                          context
                              .read<TasksBloc>()
                              .add(SortTaskEvent(sortOption: 2));
                          break;
                        }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(LucideIcons.calendar_days),
                            const Gap(10),
                            Text(
                              'Sort by date',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(LucideIcons.clipboard_check),
                            const Gap(10),
                            Text(
                              'Completed tasks',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(LucideIcons.clipboard_list),
                            const Gap(10),
                            Text(
                              'Pending tasks',
                              style: theme.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),
          body: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<TasksBloc, TasksState>(
                listener: (context, state) {
                  if (state is LoadTaskFailure) {
                    context.showErrorSnackBar(state.error);
                  }
                  if (state is AddTaskFailure || state is UpdateTaskFailure) {
                    context.read<TasksBloc>().add(FetchTaskEvent());
                  }
                },
                builder: (context, state) {
                  if (state is TasksLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  if (state is LoadTaskFailure) {
                    return Center(
                        child: Text(
                      state.error,
                      style: theme.textTheme.bodySmall,
                    )
                        // buildText(
                        //     state.error,
                        //     kBlackColor,
                        //     textMedium,
                        //     FontWeight.normal,
                        //     TextAlign.center,
                        //     TextOverflow.clip),
                        );
                  }

                  if (state is FetchTasksSuccess) {
                    return state.tasks.isNotEmpty || state.isSearching
                        ? Column(
                            children: [
                              CustomTextField(
                                  hint: "Search recent task",
                                  controller: searchController,
                                  inputType: TextInputType.text,
                                  prefixIcon: const Icon(LucideIcons.search),
                                  onChanged: (value) {
                                    context
                                        .read<TasksBloc>()
                                        .add(SearchTaskEvent(keywords: value));
                                  }),
                              const Gap(20),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: state.tasks.length,
                                  itemBuilder: (context, index) {
                                    return TaskItemView(
                                        taskModel: state.tasks[index]);
                                  },
                                  separatorBuilder: (_, __) =>
                                      const Divider(color: kGrey3),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/tasks.svg',
                                  height: size.height * .20,
                                  width: size.width,
                                ),
                                const Gap(50),
                                Text(
                                  'Schedule your tasks',
                                  style: theme.textTheme.headlineLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Manage your task schedule easily\nand efficiently',
                                  style: theme.textTheme.labelMedium,
                                ),
                              ],
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.large(
            child: const Icon(
              Icons.add_circle,
              size: 45,
            ),
            onPressed: () async {
              await Navigator.pushNamed(context, Pages.addUpdateTask);
            },
          ),
        ),
      ),
    );
  }
}
