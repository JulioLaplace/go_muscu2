import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/models/exercise_data.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';

class ExerciseProvider extends ChangeNotifier {
  // Training provider
  final WorkoutProvider? workoutProvider;

  ExerciseProvider(this.workoutProvider);

  // List of trainings
  List<Exercise> exercises = [];

  // already loaded
  bool alreadyLoaded = false;

  // Current user connected
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Firebase instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Current exercise selected
  Exercise? currentExercise;

  // Document reference
  CollectionReference exerciseCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection('exercises');

  // Document reference for exercise data
  CollectionReference exerciseDataCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection('exerciseData');

  // Get all exercises
  Future<List<Exercise>> getExercises() async {
    exercises = [];
    await exerciseCollection.get().then((records) {
      for (var element in records.docs) {
        exercises.add(Exercise.fromJson(
            element.data() as Map<String, dynamic>, element.id));
      }
    });
    return exercises;
  }

  // Add an exercise
  addExercise(Exercise exercise, BuildContext context) async {
    // remote adding
    await exerciseCollection.add(exercise.toJson()).then((value) {
      exercise.id = value.id;
      // update remote id
      exerciseCollection.doc(value.id).update({'id': value.id});
      // local adding
      exercises.add(exercise);
      alreadyLoaded = false;
      notifyListeners();
      return Utils.validationPopUp(context, 'Exercise added');
    }).catchError(
        (error) => Utils.errorPopUp(context, 'Failed to add exercise'));
  }

  // Remove an exercise
  removeExercise(Exercise exercise, BuildContext context) async {
    log('Removing exercise ${exercise.id}');
    // remote removing
    await exerciseCollection
        .doc(exercise.id)
        .delete()
        .then((value) => {})
        .catchError((error) => {});
    // local removing
    exercises.remove(exercise);

    // remove all data from the exercise
    await removeAllDataFromExercise(exercise.id);

    // remove exercise from all workouts
    await workoutProvider!.removeExerciseFromAllWorkouts(exercise);
    notifyListeners();
  }

  // Remove all data from an exercise
  removeAllDataFromExercise(String id) async {
    // We have to delete all collection data related to the current document
    log('Removing all data from exercise $id');
    // remove 'data' collection
    await exerciseDataCollection.doc(id).collection('data').get().then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
    });

    // remove the document
    await exerciseDataCollection
        .doc(id)
        .delete()
        .then((value) => log('All data from exercise $id removed'));
  }

  // Edit an exercise
  editExercise(Exercise exercise, BuildContext context,
      [bool noteEditing = false]) async {
    // remote editing
    await exerciseCollection
        .doc(exercise.id)
        .update(exercise.toJson())
        .then((value) {
      // local editing
      exercises[exercises.indexWhere((element) => element.id == exercise.id)] =
          exercise;

      if (!noteEditing) {
        notifyListeners();
        return Utils.validationPopUp(context, 'Training edited');
      }
    }).catchError((error) =>
            noteEditing ? null : Utils.errorPopUp(context, 'Failed to edit'));
    workoutProvider!.editExerciseInAllWorkouts(exercise, true);
  }

  /*----------------------------------------------------------------------------
   * Current exercise
   ---------------------------------------------------------------------------*/

  // Set current exercise
  setCurrentExercise(Exercise exercise) {
    currentExercise = exercise;
    notifyListeners();
  }

  // Unset current exercise
  unsetCurrentExercise() {
    log('Current exercise unset');
    currentExercise = null;
    notifyListeners();
  }

  // Get exercise data from the current exercise from firestore
  // Get the last 2 most recent data
  Future getExerciseData([int limit = 3]) async {
    log('Getting exercise data');
    List<ExerciseData> data = [];
    await exerciseDataCollection
        .doc(currentExercise!.id)
        .collection('data')
        .orderBy('date', descending: true)
        .limit(limit)
        .get()
        .then((records) {
      for (var element in records.docs) {
        data.add(ExerciseData.fromJson(element.data(), element.id));
      }
    });
    currentExercise!.data = data;
    notifyListeners();
    return data.length;
  }

  // Add exercise data to the current exercise
  addExerciseData(ExerciseData data) async {
    // remote adding
    await exerciseDataCollection
        .doc(currentExercise!.id)
        .collection('data')
        .add(data.toJson())
        .then((value) {
      data.id = value.id;
      // update remote id
      exerciseDataCollection
          .doc(currentExercise!.id)
          .collection('data')
          .doc(value.id)
          .update({'id': value.id});
      // local adding
      currentExercise!.data.add(data);
      notifyListeners();
    });
  }
}
