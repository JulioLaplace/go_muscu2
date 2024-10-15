import 'package:flutter/material.dart';

class AddExerciseProvider with ChangeNotifier {
  String _exerciseName = '';
  String? _exerciseCategory;
  bool _isUnilateral = false;
  String _setNumberGoal = '';
  String _repNumberGoal = '';

  void setExerciseName(String value) {
    _exerciseName = value;
  }

  void setExerciseCategory(String? value) {
    _exerciseCategory = value;
  }

  void setIsUnilateral(bool value) {
    _isUnilateral = value;
  }

  void setSetNumberGoal(String value) {
    _setNumberGoal = value;
  }

  void setRepNumberGoal(String value) {
    _repNumberGoal = value;
  }

  void reset() {
    _exerciseName = '';
    _exerciseCategory = null;
    _isUnilateral = false;
    _setNumberGoal = '';
    _repNumberGoal = '';
    notifyListeners();
  }

  String get exerciseName => _exerciseName;
  String? get exerciseCategory => _exerciseCategory;
  bool get isUnilateral => _isUnilateral;
  String get setNumberGoal => _setNumberGoal;
  String get repNumberGoal => _repNumberGoal;
}
