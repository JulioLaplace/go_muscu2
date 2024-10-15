import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/models/exercise_data.dart';
import 'package:go_muscu2/models/setsAndReps/bilateral_set_and_rep.dart';
import 'package:go_muscu2/models/setsAndReps/set_and_rep.dart';
import 'package:go_muscu2/models/setsAndReps/unilateral_set_and_rep.dart';
import 'package:go_muscu2/models/training.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentExerciseDataProvider with ChangeNotifier {
  // Current training provider
  final CurrentWorkoutProvider? currentTrainingProvider;

  CurrentExerciseDataProvider(this.currentTrainingProvider);

  // Current training
  Training? get currentTraining => currentTrainingProvider!.currentTraining;

  // Dynamic data of the current training : exerciseId -> ExerciseData
  Map<String, ExerciseData> currentDataExercises = {};
  DateTime? date;

  // Data already loaded
  bool alreadyLoaded = false;

  // Current textfield value
  String currentTextFieldValue = '';

  // Initialize the map with the exercises of the current training
  Future initializeExercisesData() async {
    if (this.dataLoadedFromLocal == true) {
      return;
    }
    date = DateTime.now();

    // Initialize the data
    for (var exercise in currentTraining!.exercises) {
      // Try to get previous local data in storage
      ExerciseData? localData = await getLocalExerciseData(exercise.id);
      if (localData != null) {
        currentDataExercises[exercise.id] =
            await clearLocalExerciseData(localData);
        continue;
      }

      // Create empty set of data
      // for each exercise of the current training
      // There are as many sets as the set number goal
      currentDataExercises[exercise.id] = ExerciseData(
        id: exercise.id, // Random id generated in Firebase
        date: date ?? DateTime.now(),
        setsAndReps: getEmptySetsAndReps(exercise),
      );

      // Local saving
      log('Setting local exercise data for exercise ${exercise.id}');
      await setLocalExerciseData(currentDataExercises[exercise.id]!);
    }

    // Set data initialized
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }
    sharedPreferences!.setBool('dataInitialized', true);
    log('Data initialized');

    notifyListeners();
  }

  // Clear local exercise data: remove note, and date
  Future<ExerciseData> clearLocalExerciseData(ExerciseData exercise) async {
    // Clear date
    exercise.date = date ?? DateTime.now();

    // Clear note
    for (var setAndRep in exercise.setsAndReps) {
      setAndRep.note = '';
    }

    // Local saving
    log('Clearing local exercise data for exercise ${exercise.id}');
    await setLocalExerciseData(exercise);

    return exercise;
  }

  // Create a list of empty sets and reps for an exercise
  List<SetAndRep> getEmptySetsAndReps(Exercise exercise) {
    List<SetAndRep> setsAndReps = [];
    for (int i = 0; i < int.parse(exercise.setNumberGoal); i++) {
      if (exercise.unilateral) {
        setsAndReps
            .add(getEmptySetAndRepUnilateral(i + 1, exercise.repNumberGoal));
      } else {
        setsAndReps
            .add(getEmptySetAndRepBilateral(i + 1, exercise.repNumberGoal));
      }
    }
    return setsAndReps;
  }

  BilateralSetAndRep getEmptySetAndRepBilateral(
      int setNumber, String repNumberGoal) {
    return BilateralSetAndRep(
      setNumber: setNumber,
      note: '',
      repNumber: repNumberGoal,
      weight: '0',
      additionalRepNumber: '',
      additionalWeight: '',
    );
  }

  UnilateralSetAndRep getEmptySetAndRepUnilateral(
      int setNumber, String repNumberGoal) {
    return UnilateralSetAndRep(
      setNumber: setNumber,
      note: '',
      repNumberLeft: repNumberGoal,
      weightLeft: '0',
      additionalRepNumberLeft: '',
      additionalWeightLeft: '',
      repNumberRight: repNumberGoal,
      weightRight: '0',
      additionalRepNumberRight: '',
      additionalWeightRight: '',
    );
  }

  // Change exercise data when changing the exercise
  changeExerciseData(Exercise newExercise) {
    if (isExerciseInWorkout(newExercise)) {
      if (!hasExerciseDataInCurrentTraining(newExercise.id)) {
        currentDataExercises[newExercise.id] = ExerciseData(
          id: '', // Random id generated in Firebase
          date: date ?? DateTime.now(),
          setsAndReps: getEmptySetsAndReps(newExercise),
        );
        notifyListeners();
      } else {
        return;
      }
    } else {
      if (hasExerciseDataInCurrentTraining(newExercise.id)) {
        currentDataExercises.remove(newExercise.id);
        log('Current exercise data: ${currentDataExercises.length}');
        notifyListeners();
      } else {
        return;
      }
    }

    // print exercises in current training
    for (var exercise in currentTraining!.exercises) {
      log('Exercise ${exercise.id}');
    }
    notifyListeners();
  }

  // check if exercise is already in the current workout
  bool isExerciseInWorkout(Exercise newExercise) {
    for (var exercise in currentTraining!.exercises) {
      if (exercise.id == newExercise.id) {
        return true;
      }
    }
    return false;
  }

  bool hasExerciseDataInCurrentTraining(String exerciseId) {
    return currentDataExercises.containsKey(exerciseId);
  }

  // Get the exercise data of an exercise given its id
  ExerciseData? getExerciseData(String exerciseId) {
    return currentDataExercises[exerciseId];
  }

  // Save all the exercise data of the current training
  saveAllExerciseData() async {
    for (var exercise in currentTraining!.exercises) {
      await saveExerciseData(exercise.id);
    }
  }

  // Clear the current exercise data
  clearCurrentExerciseData() {
    currentDataExercises = {};
    alreadyLoaded = false;
    currentTextFieldValue = '';
    notifyListeners();
  }

  // Verify the exercises data
  bool verifyExercisesData() {
    for (var exercise in currentTraining!.exercises) {
      for (var setAndRep in currentDataExercises[exercise.id]!.setsAndReps) {
        if (exercise.unilateral) {
          if (setAndRep is UnilateralSetAndRep) {
            if (setAndRep.repNumberLeft.isEmpty ||
                setAndRep.repNumberLeft == '0' ||
                setAndRep.weightLeft.isEmpty ||
                setAndRep.additionalRepNumberLeft == '0' ||
                setAndRep.repNumberRight.isEmpty ||
                setAndRep.repNumberRight == '0' ||
                setAndRep.weightRight.isEmpty ||
                setAndRep.additionalRepNumberRight == '0') {
              return false;
            }
          }
        } else {
          if (setAndRep is BilateralSetAndRep) {
            if (setAndRep.repNumber.isEmpty ||
                setAndRep.repNumber == '0' ||
                setAndRep.weight.isEmpty ||
                setAndRep.additionalRepNumber == '0') {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  // Terminate the current training
  terminateTraining(BuildContext context) async {
    // Verify exercises data
    if (!verifyExercisesData()) {
      Utils.errorPopUp(context, 'Please fill all the fields');
      return false;
    }
    // Save all the exercise data
    await saveAllExerciseData();
    // Clear current exercise data
    currentDataExercises = {};
    // Remove local saved data
    await removeLocalSavedData();
    // Stop the current training
    await currentTrainingProvider!.stopCurrentTraining();
    return true;
  }

  // ---------------------------------------------------------------------------
  // -------------------- Exercise Data for one exercise -----------------------
  // ---------------------------------------------------------------------------

  // Document reference for exercise data
  CollectionReference exerciseDataCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection('exerciseData');

  // Set the exercise data of an exercise given its id
  void setExerciseData(
    String exerciseId,
    List<SetAndRep> setsAndReps,
  ) {
    log('Setting exercise data for exercise $exerciseId');
    // Data in provider
    currentDataExercises[exerciseId]?.setsAndReps = setsAndReps;

    // Local saving
    setLocalExerciseData(currentDataExercises[exerciseId]!);

    notifyListeners();
  }

  // Save the exercise data of an exercise given its id
  saveExerciseData(String exerciseId,
      [bool displayResponse = false, BuildContext? context = null]) async {
    // Save the data in the database
    log('Saving exercise data for exercise $exerciseId');

    // Add the data
    await exerciseDataCollection
        .doc(exerciseId)
        .collection('data')
        .add(currentDataExercises[exerciseId]!.toJson())
        .then((value) {
      // set exercise data id
      currentDataExercises[exerciseId]!.id = value.id;
      // update remote id
      exerciseDataCollection
          .doc(exerciseId)
          .collection('data')
          .doc(value.id)
          .update({'id': value.id});
      notifyListeners();
      return displayResponse
          ? Utils.validationPopUp(context!, 'Exercise data saved')
          : null;
    }).catchError((error) => displayResponse
            ? Utils.errorPopUp(context!, 'Failed to save exercise data')
            : null);
  }

  updateExerciseData(
      String exerciseId, bool displayResponse, BuildContext? context) async {
    exerciseDataCollection
        .doc(exerciseId)
        .collection('data')
        .doc(currentDataExercises[exerciseId]!.id)
        .update(currentDataExercises[exerciseId]!.toJson())
        .then((value) {
      notifyListeners();
      return displayResponse
          ? Utils.validationPopUp(context!, 'Exercise data updated')
          : null;
    }).catchError((error) => displayResponse
            ? Utils.errorPopUp(context!, 'Failed to update exercise data')
            : null);
  }

  // ---------------------------------------------------------------------------
  // -------------------------------- Local save -------------------------------
  // ---------------------------------------------------------------------------

  SharedPreferences? sharedPreferences;

  bool? dataInitialized;

  bool? dataLoadedFromLocal;

  // Use of shared preferences

  // Initialize shared preferences
  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // Save current exercise data in shared preferences
  setLocalExerciseData(ExerciseData exerciseData) async {
    // Get shared preferences instance
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }

    log('Saving exercise data in local storage: ${exerciseData.id}');

    // Save current exercise data
    Map<String, dynamic> exerciseDataJson =
        exerciseData.toJsonWithoutTimestamp();
    // log('Exercise data: $exerciseDataJson');
    sharedPreferences!.setString(exerciseData.id, jsonEncode(exerciseDataJson));
  }

  // Get current exercise data from shared preferences
  getLocalExerciseData(String exerciseDataId) async {
    log('Getting local exercise data: $exerciseDataId');
    // Get shared preferences instance
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }

    // Get current exercise data
    String? exerciseDataJson = sharedPreferences!.getString(exerciseDataId);
    // log(exerciseDataJson!);
    if (exerciseDataJson != null) {
      Map<String, dynamic> exerciseDataMap = jsonDecode(exerciseDataJson);
      // log all of the data
      return ExerciseData.fromJsonWithoutTimestamp(exerciseDataMap);
    } else {
      return null;
    }
  }

  getAllLocalExerciseData() async {
    if (currentTraining == null) {
      log('Current training is null');
      return;
    }
    if (this.currentDataExercises.isNotEmpty) {
      log('Current data exercises is not empty');
      return;
    }
    if (this.dataLoadedFromLocal == true) {
      log('Data already loaded from local');
      return;
    }
    // Get shared preferences instance
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }

    // Check if data is already initialized
    this.dataInitialized = sharedPreferences!.getBool('dataInitialized');
    if (dataInitialized == null || dataInitialized == false) {
      // Data not initialized
      log('Data not initialized');
      return;
    }

    log('Data already initialized');

    Map<String, ExerciseData> currentDataExercisesLocal = {};

    // Get all current exercise data
    for (var exercise in currentTraining!.exercises) {
      String? exerciseDataJson = sharedPreferences!.getString(exercise.id);
      if (exerciseDataJson != null) {
        currentDataExercisesLocal[exercise.id] =
            await getLocalExerciseData(exercise.id);
      }
    }

    // Set data loaded from local
    this.dataLoadedFromLocal = true;
    log('Data loaded from local: ${currentDataExercisesLocal.length} exercises');

    this.currentDataExercises = currentDataExercisesLocal;
    notifyListeners();
  }

  removeLocalSavedData() async {
    // Get shared preferences instance
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }

    // Remove all current exercise data
    // for (var exercise in currentTraining!.exercises) {
    //   sharedPreferences!.remove(exercise.id);
    // }

    // Remove data initialized
    sharedPreferences!.remove('dataInitialized');

    // Reset data loaded from local
    this.dataLoadedFromLocal = false;
  }

  // ---------------------------------------------------------------------------
  // ---------------------------- Add one exercise data ------------------------
  // ---------------------------------------------------------------------------

  // Initialize the exercise data (local)
  Future<void> initializeExerciseData(Exercise exercise) async {
    // Try to get previous local data in storage
    ExerciseData? localData = await getLocalExerciseData(exercise.id);
    if (localData != null) {
      currentDataExercises[exercise.id] =
          await clearLocalExerciseData(localData);
      return;
    }

    // Create empty set of data if not already initialized
    currentDataExercises[exercise.id] = ExerciseData(
      id: exercise.id, // Random id generated in Firebase
      date: DateTime.now(),
      setsAndReps: getEmptySetsAndReps(exercise),
    );

    // Local saving
    log('Setting local exercise data for exercise ${exercise.id}');
    await setLocalExerciseData(currentDataExercises[exercise.id]!);
  }
}
