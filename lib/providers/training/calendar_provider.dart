import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_muscu2/models/training.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarProvider with ChangeNotifier {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  CalendarFormat calendarFormat = CalendarFormat.week;

  // setters for values
  void setSelectedDay(DateTime day) {
    selectedDay = day;
    notifyListeners();
  }

  void setFocusedDay(DateTime day) {
    focusedDay = day;
    notifyListeners();
  }

  void setCalendarFormat(CalendarFormat format) {
    calendarFormat = format;
    notifyListeners();
  }

  // getters for accessing values
  DateTime get getSelectedDay => selectedDay;
  DateTime get getFocusedDay => focusedDay;
  CalendarFormat get getCalendarFormat => calendarFormat;

  // -------------------------- Trainings --------------------------------------

  bool reloadWidget = false;

  Training? trainingToReplace;

  SharedPreferences? sharedPreferences;

  // Initialize shared preferences
  Future<void> initSharedPreferences() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  // Set training to replace
  void setTrainingToReplace(Training training) {
    trainingToReplace = training;
    notifyListeners();
  }

  // Unset training to replace
  void unsetTrainingToReplace() {
    trainingToReplace = null;
    notifyListeners();
  }

  // Get trainings for the day
  Future<List<Training>> getTrainingsForDay(DateTime day) async {
    // Init shared preferences
    await initSharedPreferences();

    String date = day.toString().split(' ')[0];

    // Get trainings for the day
    List<String>? trainingsStr = [];
    List<dynamic> trainingsMap = [];
    List<Training> selectedTrainings = [];
    if (sharedPreferences!.containsKey(date)) {
      trainingsStr = sharedPreferences!.getStringList(date);
      trainingsMap = trainingsStr!.map((e) => jsonDecode(e)).toList();
      selectedTrainings = trainingsMap
          .map((e) => Training.fromJsonWithoutTimestamp(e))
          .toList();
    }

    log('Trainings for $date: $selectedTrainings');

    return selectedTrainings;
  }

  // Add one training for the day
  Future<void> addTrainingForDay(DateTime day, Training training) async {
    // Init shared preferences
    await initSharedPreferences();

    String date = day.toString().split(' ')[0];

    // Get trainings for the day
    List<String>? trainingsStr = [];
    List<dynamic> trainingsMap = [];
    List<Training> selectedTrainings = [];
    if (sharedPreferences!.containsKey(date)) {
      trainingsStr = sharedPreferences!.getStringList(date);
      trainingsMap = trainingsStr!.map((e) => jsonDecode(e)).toList();
      selectedTrainings = trainingsMap
          .map((e) => Training.fromJsonWithoutTimestamp(e))
          .toList();
    }

    // Check if training is already in the list
    for (var t in selectedTrainings) {
      if (t.id == training.id) {
        return;
      }
    }

    // Add training for the day
    selectedTrainings.add(training);
    List<String> trainingsStrNew = selectedTrainings
        .map((e) => jsonEncode(e.toJsonWithoutTimestamp()))
        .toList();
    sharedPreferences!.setStringList(date, trainingsStrNew);

    log('Training added for $date: $training');

    reloadWidget = true;
    notifyListeners();
  }

  // Remove one training for the day
  Future<void> removeTrainingForDay(DateTime day, Training training) async {
    // Init shared preferences
    await initSharedPreferences();

    String date = day.toString().split(' ')[0];

    // Get trainings for the day
    List<String>? trainingsStr = [];
    List<dynamic> trainingsMap = [];
    List<Training> selectedTrainings = [];
    if (sharedPreferences!.containsKey(date)) {
      trainingsStr = sharedPreferences!.getStringList(date);
      trainingsMap = trainingsStr!.map((e) => jsonDecode(e)).toList();
      selectedTrainings = trainingsMap
          .map((e) => Training.fromJsonWithoutTimestamp(e))
          .toList();
    }

    // Compare trainings ids to remove the right one
    for (var t in selectedTrainings) {
      if (t.id == training.id) {
        selectedTrainings.remove(t);
        break;
      } else {
        return;
      }
    }
    // Remove training for the day
    List<String> trainingsStrNew = selectedTrainings
        .map((e) => jsonEncode(e.toJsonWithoutTimestamp()))
        .toList();
    sharedPreferences!.setStringList(date, trainingsStrNew);

    reloadWidget = true;
    notifyListeners();

    log('Training removed for $date: $training');
  }

  // Replace one training for the day
  Future<void> replaceTrainingForDay(DateTime day, Training newTraining) async {
    // Init shared preferences
    await initSharedPreferences();

    String date = day.toString().split(' ')[0];

    // Get trainings for the day
    List<String>? trainingsStr = [];
    List<dynamic> trainingsMap = [];
    List<Training> selectedTrainings = [];
    if (sharedPreferences!.containsKey(date)) {
      trainingsStr = sharedPreferences!.getStringList(date);
      trainingsMap = trainingsStr!.map((e) => jsonDecode(e)).toList();
      selectedTrainings = trainingsMap
          .map((e) => Training.fromJsonWithoutTimestamp(e))
          .toList();
    }

    // Compare trainings ids to remove the right one
    for (int i = 0; i < selectedTrainings.length; i++) {
      if (selectedTrainings[i].id == newTraining.id) {
        return;
      }
      if (selectedTrainings[i].id == trainingToReplace!.id) {
        selectedTrainings[i] = newTraining;
        break;
      }
    }
    // Replace training for the day
    List<String> trainingsStrNew = selectedTrainings
        .map((e) => jsonEncode(e.toJsonWithoutTimestamp()))
        .toList();
    sharedPreferences!.setStringList(date, trainingsStrNew);

    reloadWidget = true;
    notifyListeners();

    log('Training replaced for $date: $trainingToReplace by $newTraining');
  }

  // Get all the markers for the calendar
  List<dynamic> getMarkerEvents(DateTime day) {
    // Init shared preferences
    initSharedPreferences();

    String date = day.toString().split(' ')[0];

    // Get trainings for the day
    List<String>? trainingsStr = [];
    List<dynamic> trainingsMap = [];
    List<Training> selectedTrainings = [];
    if (sharedPreferences == null) {
      return [];
    }
    if (sharedPreferences!.containsKey(date)) {
      trainingsStr = sharedPreferences!.getStringList(date);
      trainingsMap = trainingsStr!.map((e) => jsonDecode(e)).toList();
      selectedTrainings = trainingsMap
          .map((e) => Training.fromJsonWithoutTimestamp(e))
          .toList();
    }

    // Get the markers for the day
    List markers = [];
    for (int i = 0; i < selectedTrainings.length; i++) {
      markers.add(1);
    }

    return markers;
  }
}
