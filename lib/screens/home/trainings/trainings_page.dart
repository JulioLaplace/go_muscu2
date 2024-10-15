import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/home/add_button.dart';
import 'package:go_muscu2/models/training.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/training/calendar_provider.dart';
import 'package:go_muscu2/screens/home/workouts/workouts_page.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_muscu2/components/constants.dart' as constants;

class TrainingsPage extends StatefulWidget {
  const TrainingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  // -------------------------- Attribures -------------------------------------
  late List<Training> _selectedTrainings;
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  bool isLoading = true;
  bool alreadyLoaded = false;

  // -------------------------- Init -------------------------------------------
  @override
  void initState() {
    _selectedTrainings = [];
    super.initState();
  }

  // -------------------------- Methods ----------------------------------------
  void _loadTrainings(CalendarProvider calendarProvider) {
    if (!alreadyLoaded || calendarProvider.reloadWidget) {
      calendarProvider.getTrainingsForDay(_selectedDay).then((trainings) {
        setState(() {
          _selectedTrainings = trainings;
          isLoading = false;
          alreadyLoaded = true;
          calendarProvider.reloadWidget = false;
        });
      });
    }
  }

  // Choosing workout page to add to the calendar
  chooseWorkoutPage(
    BottomSheetProvider bottomSheetProvider,
  ) {
    bottomSheetProvider.setBottomSheetWidget(
      WorkoutsPage(
        addingWorkoutMode: true,
      ),
    );
    bottomSheetProvider.setBottomSheetHeight(constants.screenHeigth);
    bottomSheetProvider.openBottomSheet();
  }

  // -------------------------- Dispose ----------------------------------------
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<CalendarProvider>(
        builder: (context, calendarProvider, child) {
          // get values from provider
          _selectedDay = calendarProvider.getSelectedDay;
          _focusedDay = calendarProvider.getFocusedDay;

          // if (calendarProvider.reloadWidget) {
          //   WidgetsBinding.instance!.addPostFrameCallback((_) {
          //     // executes after build
          //     setState(() {});
          //   });
          //   calendarProvider.reloadWidget = false;
          // }

          // Load trainings for selected day
          _loadTrainings(calendarProvider);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(doubleRadius),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2050, 3, 14),
                    focusedDay: _focusedDay,
                    currentDay: DateTime.now(),
                    daysOfWeekHeight: 30,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: Theme.of(context).textTheme.bodySmall!,
                      weekendStyle: Theme.of(context).textTheme.bodySmall!,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      tablePadding: const EdgeInsets.symmetric(vertical: 10),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
                      outsideTextStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                              ),
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    calendarFormat: calendarProvider.calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onFormatChanged: (format) {
                      calendarProvider.setCalendarFormat(format);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        calendarProvider.setSelectedDay(selectedDay);
                        calendarProvider.setFocusedDay(focusedDay);
                        alreadyLoaded = false;
                        isLoading = true;
                      });
                    },
                    onPageChanged: (focusedDay) async {
                      calendarProvider.setFocusedDay(focusedDay);
                    },
                    eventLoader: (day) {
                      return calendarProvider.getMarkerEvents(day);
                    },
                  ),
                ),
              ),

              // Add training button
              Consumer<BottomSheetProvider>(
                builder: (context, bottomSheetProvider, child) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: AddButton(
                    onTap: () {
                      chooseWorkoutPage(
                        bottomSheetProvider,
                      );
                    },
                  ),
                ),
              ),

              // Trainings list
              isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: WorkoutsPage(
                        trainings: _selectedTrainings,
                        calendarMode: true,
                        displayInfo: false,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
