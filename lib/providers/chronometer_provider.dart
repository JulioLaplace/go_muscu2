import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class ChronometerProvider with ChangeNotifier {
  // Boolean to check if the chronometer is running
  bool isPlaying = false;
  bool isVisible = false;
  DateTime? startTime;
  DateTime? pauseTime;

  // Chronometer
  int minutes = 0;
  String minutesStr = '00';
  int seconds = 0;
  late String secondsStr = '00';
  int milliseconds = 0;
  late String millisecondsStr = '00';

// start timer
  void startTimer() {
    if (startTime == null) {
      startTime = DateTime.now();
    }
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (isPlaying) {
        updateTimer();
      } else {
        timer.cancel();
        notifyListeners();
      }
    });
  }

  // update timer when initstate is called to compare the start time and the
  // current time
  updateTimer() {
    if (startTime != null) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(startTime!);
      if (pauseTime != null) {
        Duration pauseDifference = now.difference(pauseTime!);
        startTime = startTime!.add(pauseDifference);
        difference = now.difference(startTime!);
        pauseTime = null;
      }
      minutes = difference.inMinutes;
      seconds = difference.inSeconds.remainder(60);
      milliseconds = difference.inMilliseconds.remainder(100);
      minutesStr = minutes.toString().padLeft(2, '0');
      secondsStr = seconds.toString().padLeft(2, '0');
      millisecondsStr = milliseconds.toString().padLeft(2, '0');

      // log the time
      notifyListeners();
    }
  }

  // stop timer
  // reset button
  void resetTimer() {
    isPlaying = false;
    isVisible = false;
    minutes = 0;
    seconds = 0;
    milliseconds = 0;
    minutesStr = minutes.toString().padLeft(2, '0');
    secondsStr = seconds.toString().padLeft(2, '0');
    millisecondsStr = milliseconds.toString().padLeft(2, '0');
    startTime = null;
    pauseTime = null;
    notifyListeners();
  }

  // Method called if the related widget is disposed
  // the timer disposes but does not reset the timer
  void disposeTimer() {
    isPlaying = false;
    isVisible = false;
    notifyListeners();
  }

  // setters for boolean values
  void setIsPlaying(bool value) {
    isPlaying = value;
    notifyListeners();
  }

  void setIsVisible(bool value) {
    isVisible = value;
    notifyListeners();
  }

  // Getters for accessing the chronometer values
  String get getMinutesStr => minutesStr;
  String get getSecondsStr => secondsStr;
  String get getMillisecondsStr => millisecondsStr;
  bool get getIsPlaying => isPlaying;
  bool get getIsVisible => isVisible;
}
