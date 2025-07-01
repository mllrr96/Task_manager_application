import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager_app/components/custom_app_bar.dart';
import 'package:task_manager_app/components/custom_text_field.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:task_manager_app/utils/datetime_extension.dart';
import 'package:task_manager_app/utils/scaffold_messenger_extension.dart';

class AddUpdateTaskScreen extends StatefulWidget {
  const AddUpdateTaskScreen({super.key, this.task});

  final TaskModel? task;

  @override
  State<AddUpdateTaskScreen> createState() => _AddUpdateTaskScreenState();
}

class _AddUpdateTaskScreenState extends State<AddUpdateTaskScreen> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  late final bool isUpdatingTask;
  bool showFAB = false;
  final titleFocusNode = FocusNode();
  final descFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    isUpdatingTask = widget.task != null;
    if (isUpdatingTask) {
      _loadTaskData(widget.task!);
    }
    titleFocusNode.addListener(_handleTitleFocus);
    descFocusNode.addListener(_handleDescFocus);
    super.initState();
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    descFocusNode.dispose();
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.dispose();
  }

  void _handleTitleFocus() {
    if (titleFocusNode.hasFocus) {
      if (!showFAB) {
        setState(() => showFAB = true);
      }
    } else {
      if (showFAB) {
        setState(() => showFAB = false);
      }
    }
  }

  void _handleDescFocus() {
    if (descFocusNode.hasFocus) {
      if (!showFAB) {
        setState(() => showFAB = true);
      }
    } else {
      if (showFAB) {
        setState(() => showFAB = false);
      }
    }
  }

  void _loadTaskData(TaskModel task) {
    titleCtrl.text = task.title;
    descriptionCtrl.text = task.description;
    _selectedDay = _focusedDay;
    _rangeStart = task.startDateTime;
    _rangeEnd = task.stopDateTime;
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  void _addNewTask(TaskModel task) {
    final String taskId = DateTime.now().millisecondsSinceEpoch.toString();

    context.read<TasksBloc>().add(
          AddNewTaskEvent(taskModel: task.copyWith(id: taskId)),
        );
  }

  void _updateTask(TaskModel task) {
    final updatedTask = task.copyWith(
      id: widget.task!.id,
      completed: widget.task!.completed,
    );
    // If the task is the same (user changed nothing) go back
    if (updatedTask == widget.task) {
      Navigator.pop(context);
    } else {
      context.read<TasksBloc>().add(
            UpdateTaskEvent(taskModel: updatedTask),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final appBarTitle = isUpdatingTask ? 'Update Task' : 'Create New Task';
    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
        systemUiOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
        ),
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              child: Icon(LucideIcons.arrow_down),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            )
          : null,
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
        child: Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text('Cancel'),
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              child: FilledButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      WidgetStateProperty.all<Color>(kPrimaryColor),
                ),
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final taskModel = TaskModel(
                    id: '',
                    title: titleCtrl.text,
                    description: descriptionCtrl.text,
                    startDateTime: _rangeStart,
                    stopDateTime: _rangeEnd,
                  );

                  if (isUpdatingTask) {
                    _updateTask(taskModel);
                  } else {
                    _addNewTask(taskModel);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(isUpdatingTask ? 'Update' : 'Save'),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<TasksBloc, TasksState>(
            listener: (context, state) {
              if (state is AddTaskFailure) {
                context.showErrorSnackBar(state.error);
              }
              if (state is UpdateTaskFailure) {
                context.showErrorSnackBar(state.error);
              }
              if (state is AddTasksSuccess || state is UpdateTaskSuccess) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return ListView(
                children: [
                  TableCalendar(
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.week: 'Week',
                    },
                    rangeSelectionMode: RangeSelectionMode.toggledOn,
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2030, 1, 1),
                    onPageChanged: (focusDay) {
                      _focusedDay = focusDay;
                    },
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onRangeSelected: _onRangeSelected,
                  ),
                  const Gap(20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                        color: kPrimaryColor.withValues(alpha: 0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      _rangeStart != null && _rangeEnd != null
                          ? 'Task starting at ${_rangeStart!.format()} - ${_rangeEnd!.format()}'
                          : 'Select a date range',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  Gap(5),
                  Divider(),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title',
                          style: theme.textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        CustomTextField(
                          focusNode: titleFocusNode,
                          hint: "Task Title",
                          controller: titleCtrl,
                          textInputAction: TextInputAction.next,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            descFocusNode.requestFocus();
                          },
                        ),
                        const Gap(20),
                        Text(
                          'Description',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Gap(10),
                        CustomTextField(
                          focusNode: descFocusNode,
                          hint: "Task Description",
                          controller: descriptionCtrl,
                          inputType: TextInputType.multiline,
                          maxLines: 3,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
