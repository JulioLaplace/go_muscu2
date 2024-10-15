import 'dart:developer';

import 'package:flutter/material.dart';

import 'dart:async';

class TimerCurrentWorkoutProvider with ChangeNotifier {
  // Boolean to check if the timer is running
  bool isPlaying = false;
  bool isVisible = false;
  DateTime? startTime;

  // Timer for current training
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  // String for timer
  String secondsString = '00';
  String minutesString = '00';
  String hoursString = '00';

  setStartTime(DateTime time) {
    startTime = time;
    isPlaying = true;
    isVisible = true;
    notifyListeners();
  }

  void startTimer() {
    if (startTime == null) {
      startTime = DateTime.now();
    }
    log('start timer: ' + startTime.toString());
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying) {
        updateTimer();
        // seconds++;
        // if (seconds == 60) {
        //   seconds = 0;
        //   minutes++;
        //   if (minutes == 60) {
        //     minutes = 0;
        //     hours++;
        //     if (hours == 3) {
        //       timer.cancel();
        //     }
        //   }
        // }
        // secondsString = seconds.toString().padLeft(2, '0');
        // minutesString = minutes.toString().padLeft(2, '0');
        // hoursString = hours.toString().padLeft(2, '0');
        // notifyListeners();
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
      final now = DateTime.now();
      final difference = now.difference(startTime!);
      hours = difference.inHours;
      minutes = difference.inMinutes % 60;
      seconds = difference.inSeconds % 60;
      hoursString = hours.toString().padLeft(2, '0');
      minutesString = minutes.toString().padLeft(2, '0');
      secondsString = seconds.toString().padLeft(2, '0');
      notifyListeners();
    }
  }

  void stopTimer() {
    setIsPlaying(false);
    seconds = 0;
    minutes = 0;
    hours = 0;
    secondsString = seconds.toString().padLeft(2, '0');
    minutesString = minutes.toString().padLeft(2, '0');
    hoursString = hours.toString().padLeft(2, '0');
    startTime = null;
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

  // getters for boolean values
  bool get getIsPlaying => isPlaying;
  bool get getIsVisible => isVisible;

  // getters for timer values
  String get getSecondsString => secondsString;
  String get getMinutesString => minutesString;
  String get getHoursString => hoursString;
}
