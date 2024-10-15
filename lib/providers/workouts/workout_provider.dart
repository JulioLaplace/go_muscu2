import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/models/training.dart';

class WorkoutProvider extends ChangeNotifier {
  // List of trainings
  List<Training> trainings = [];

  // already loaded
  bool alreadyLoaded = false;

  // Current user connected
  User currentUser = FirebaseAuth.instance.currentUser!;

  // Firebase instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Current workout selected
  Training? currentWorkout;

  // Exercise to replace
  Exercise? exerciseToReplace;

  // Document reference
  CollectionReference trainingCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection('trainings');

  /*----------------------------------------------------------------------------
   * Workouts
   ---------------------------------------------------------------------------*/

  // Get all trainings
  Future<List<Training>> getTrainings() async {
    trainings = [];
    await trainingCollection.get().then((records) {
      for (var element in records.docs) {
        trainings.add(Training.fromJson(
            element.data() as Map<String, dynamic>, element.id));
      }
    });
    return trainings;
  }

  // Add a training
  addTraining(Training training, BuildContext context) async {
    // remote adding
    await trainingCollection.add(training.toJson()).then((value) {
      training.id = value.id;
      // update remote id
      trainingCollection.doc(value.id).update({'id': value.id});
      // local adding
      trainings.add(training);
      alreadyLoaded = false;
      notifyListeners();
      return Utils.validationPopUp(context, 'Training added');
    }).catchError(
        (error) => Utils.errorPopUp(context, 'Failed to add training'));
  }

  // Edit a training
  editTraining(Training training, BuildContext context) async {
    // remote editing
    await trainingCollection
        .doc(training.id)
        .update(training.toJson())
        .then((value) {
      // local editing
      trainings[trainings.indexWhere((element) => element.id == training.id)] =
          training;
      notifyListeners();
      return Utils.validationPopUp(context, 'Training edited');
    }).catchError(
            (error) => Utils.errorPopUp(context, 'Failed to edit training'));
  }

  // Remove a training
  removeTraining(Training training, BuildContext context) async {
    // remote removing
    await trainingCollection
        .doc(training.id)
        .delete()
        .then((value) => Utils.validationPopUp(context, 'Training deleted'))
        .catchError((error) => Utils.errorPopUp(context, 'Failed to delete'));
    // local removing
    trainings.remove(training);
    notifyListeners();
  }

  /*----------------------------------------------------------------------------
   * Current workout
   ---------------------------------------------------------------------------*/

  // Set current workout
  setCurrentWorkout(Training training) {
    currentWorkout = training;
    notifyListeners();
  }

  // Unset current workout
  unsetCurrentWorkout() {
    currentWorkout = null;
    notifyListeners();
  }

  // check if exercise is already in the current workout
  bool isExerciseInWorkout(Exercise newExercise) {
    for (var exercise in currentWorkout!.exercises) {
      if (exercise.id == newExercise.id) {
        return true;
      }
    }
    return false;
  }

  // Add exercise to workout
  void addExerciseToWorkout(Exercise newExercise) {
    // local adding
    if (isExerciseInWorkout(newExercise)) return;
    currentWorkout!.exercises.add(newExercise);
    // remote adding
    trainingCollection
        .doc(currentWorkout!.id)
        .update({
          'exercises': currentWorkout!.exercises
              .map((exercise) => exercise.toJson())
              .toList()
        })
        .then((value) => {})
        .catchError((error) => {});
    notifyListeners();
  }

  // Set exercise to replace
  setExerciseToReplace(Exercise exercise) {
    exerciseToReplace = exercise;
    notifyListeners();
  }

  // Unset exercise to replace
  unsetExerciseToReplace() {
    exerciseToReplace = null;
    notifyListeners();
  }

  // Edit exercise in workout
  void editExerciseInWorkout(Exercise previousExercise, Exercise newExercise) {
    // local editing

    if (isExerciseInWorkout(newExercise)) return;
    // replace exercise with new one
    currentWorkout!.exercises[currentWorkout!.exercises
            .indexWhere((exercise) => exercise.id == previousExercise.id)] =
        newExercise;
    // remote editing
    trainingCollection
        .doc(currentWorkout!.id)
        .update({
          'exercises': currentWorkout!.exercises
              .map((exercise) => exercise.toJson())
              .toList()
        })
        .then((value) => {})
        .catchError((error) => {});
    unsetExerciseToReplace();
    notifyListeners();
  }

  // Remove exercise from workout
  void removeExerciseFromWorkout(Exercise exercise) {
    // local removing
    currentWorkout!.exercises.remove(exercise);
    // remote removing
    trainingCollection
        .doc(currentWorkout!.id)
        .update({
          'exercises': currentWorkout!.exercises
              .map((exercise) => exercise.toJson())
              .toList()
        })
        .then((value) => {})
        .catchError((error) => {});
    notifyListeners();
  }

  // Remove exercise from all workouts
  Future removeExerciseFromAllWorkouts(Exercise exerciseToDelete) async {
    log('Removing exercise from all workouts');
    for (var training in trainings) {
      if (training.exercises
          .map((exercise) => exerciseToDelete.id)
          .contains(exerciseToDelete.id)) {
        training.exercises
            .removeWhere((exercise) => exerciseToDelete.id == exercise.id);
        await trainingCollection
            .doc(training.id)
            .update({
              'exercises': training.exercises
                  .map((exercise) => exercise.toJson())
                  .toList()
            })
            .then((value) => {})
            .catchError((error) => {});
      }
    }
    notifyListeners();
  }

  // Edit exercise in all workouts
  editExerciseInAllWorkouts(Exercise exerciseToEdit,
      [bool noteEditing = false]) {
    for (var training in trainings) {
      if (training.exercises
          .map((exercise) => exerciseToEdit.id)
          .contains(exerciseToEdit.id)) {
        training.exercises[training.exercises
                .indexWhere((exercise) => exerciseToEdit.id == exercise.id)] =
            exerciseToEdit;
        trainingCollection
            .doc(training.id)
            .update({
              'exercises': training.exercises
                  .map((exercise) => exercise.toJson())
                  .toList()
            })
            .then((value) => {})
            .catchError((error) => {});
      }
    }
    if (!noteEditing) {
      notifyListeners();
    }
  }
}
