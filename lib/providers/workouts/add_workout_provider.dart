import 'package:flutter/material.dart';

class AddWorkoutProvider with ChangeNotifier {
  String _workoutName = '';
  String? _workoutCategory;

  void setWorkoutName(String value) {
    _workoutName = value;
  }

  void setWorkoutCategory(String? value) {
    _workoutCategory = value;
  }

  void reset() {
    _workoutName = '';
    _workoutCategory = null;
    notifyListeners();
  }

  String get workoutName => _workoutName;
  String? get workoutCategory => _workoutCategory;
}
