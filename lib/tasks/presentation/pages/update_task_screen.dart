import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager_app/components/custom_app_bar.dart';
import 'package:task_manager_app/components/custom_text_field.dart';
import 'package:task_manager_app/tasks/data/local/model/task_model.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:task_manager_app/utils/datetime_extension.dart';
import 'package:task_manager_app/utils/scaffold_messenger_extension.dart';

class UpdateTaskScreen extends StatefulWidget {
  final TaskModel taskModel;

  const UpdateTaskScreen({super.key, required this.taskModel});

  @override
  State<UpdateTaskScreen> createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  void initState() {
    title.text = widget.taskModel.title;
    description.text = widget.taskModel.description;
    _selectedDay = _focusedDay;
    _rangeStart = widget.taskModel.startDateTime;
    _rangeEnd = widget.taskModel.stopDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: const CustomAppBar(
          title: 'Update Task',
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<TasksBloc, TasksState>(
              listener: (context, state) {
                if (state is UpdateTaskFailure) {
                  context.showErrorSnackBar(state.error);
                }
                if (state is UpdateTaskSuccess) {
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
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
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
                          vertical: 10, horizontal: 20),
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
                      // buildText(
                      //     _rangeStart != null && _rangeEnd != null
                      //         ? 'Task starting at ${_rangeStart!.format()} - ${_rangeEnd!.format()}'
                      //         : 'Select a date range',
                      //     kPrimaryColor,
                      //     textSmall,
                      //     FontWeight.w400,
                      //     TextAlign.start,
                      //     TextOverflow.clip),
                    ),
                    const Gap(20),
                    Text(
                      'Title',
                      style: theme.textTheme.bodySmall,
                    ),
                    // buildText(
                    //     'Title',
                    //     kBlackColor,
                    //     textMedium,
                    //     FontWeight.bold,
                    //     TextAlign.start,
                    //     TextOverflow.clip),
                    const Gap(10),
                    CustomTextField(
                        hint: "Task Title",
                        controller: title,
                        inputType: TextInputType.text,
                        // fillColor: kWhiteColor,
                        onChange: (value) {}),
                    const Gap(20),
                    Text(
                      'Description',
                      style: theme.textTheme.bodySmall,
                    ),
                    // buildText(
                    //     'Description',
                    //     kBlackColor,
                    //     textMedium,
                    //     FontWeight.bold,
                    //     TextAlign.start,
                    //     TextOverflow.clip),
                    const Gap(10),
                    CustomTextField(
                        hint: "Task Description",
                        controller: description,
                        inputType: TextInputType.multiline,
                        // fillColor: kWhiteColor,
                        onChange: (value) {}),
                    const Gap(20),
                    SizedBox(
                      width: size.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(kPrimaryColor),
                        ),
                        onPressed: () {
                          var taskModel = TaskModel(
                              id: widget.taskModel.id,
                              title: title.text,
                              description: description.text,
                              completed: widget.taskModel.completed,
                              startDateTime: _rangeStart,
                              stopDateTime: _rangeEnd);
                          context
                              .read<TasksBloc>()
                              .add(UpdateTaskEvent(taskModel: taskModel));
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              'Update',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            )
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
