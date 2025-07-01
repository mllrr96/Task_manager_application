import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:gap/gap.dart';
import 'package:task_manager_app/routes/pages.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:task_manager_app/utils/datetime_extension.dart';

class TaskItemView extends StatefulWidget {
  final TaskModel taskModel;

  const TaskItemView({super.key, required this.taskModel});

  @override
  State<TaskItemView> createState() => _TaskItemViewState();
}

class _TaskItemViewState extends State<TaskItemView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.5,
            child: Checkbox(
                value: widget.taskModel.completed,
                splashRadius: 30,
                onChanged: (value) {
                  final taskModel = TaskModel(
                    id: widget.taskModel.id,
                    title: widget.taskModel.title,
                    description: widget.taskModel.description,
                    completed: !widget.taskModel.completed,
                    startDateTime: widget.taskModel.startDateTime,
                    stopDateTime: widget.taskModel.stopDateTime,
                  );
                  context
                      .read<TasksBloc>()
                      .add(UpdateTaskEvent(taskModel: taskModel));
                }),
          ),
          Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.taskModel.title,
                            style: theme.textTheme.bodyLarge,
                          ),
                          // buildText(widget.taskModel.title, kBlackColor, textMedium,
                          //     FontWeight.w500, TextAlign.start, TextOverflow.clip),
                          const Gap(5),
                          Text(
                            widget.taskModel.description,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<int>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      // color: kWhiteColor,
                      elevation: 1,
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            {
                              Navigator.pushNamed(context, Pages.addUpdateTask,
                                  arguments: widget.taskModel);
                              break;
                            }
                          case 1:
                            {
                              context.read<TasksBloc>().add(
                                  DeleteTaskEvent(taskModel: widget.taskModel));
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
                                Icon(LucideIcons.file_pen_line),
                                const Gap(10),
                                Text(
                                  'Edit task',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: Row(
                              children: [
                                Icon(LucideIcons.file_x, color: Colors.red,),
                                const Gap(10),
                                Text(
                                  'Delete task',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(LucideIcons.ellipsis_vertical),
                      ),
                    ),
                  ],
                ),
                // buildText(
                //     widget.taskModel.description,
                //     kGrey1,
                //     textSmall,
                //     FontWeight.normal,
                //     TextAlign.start,
                //     TextOverflow.clip),
                const Gap(15),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      Icon(LucideIcons.calendar_days),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          '${widget.taskModel.startDateTime?.format() ?? 'None'} - ${widget.taskModel.stopDateTime?.format() ?? 'None'}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
