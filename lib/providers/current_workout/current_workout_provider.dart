import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_muscu2/models/training.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentWorkoutProvider with ChangeNotifier {
  // Contains the current training
  Training? currentTraining;

  // True if the user is currently training
  bool isOnTraining = false;

  // True if the current training is in the bottom sheet
  // False if the user put another child in the bottom sheet
  bool isTrainingInBottomSheet = false;

  // Start time of the training
  DateTime? startTime;

  // Current user connected
  User currentUser = FirebaseAuth.instance.currentUser!;

  // Firebase instance
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Document reference
  CollectionReference trainingCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email!)
      .collection('trainings');

  void startTraining(Training training) {
    currentTraining = training;
    isOnTraining = true;
    startTime = DateTime.now();
    startTrainingSave(true, training.id, startTime!);
    notifyListeners();
  }

  Future stopCurrentTraining() async {
    // update last training date
    currentTraining!.lastTrainingDate = startTime;

    // update duration
    currentTraining!.duration = DateTime.now().difference(startTime!);

    await trainingCollection
        .doc(currentTraining!.id)
        .update(currentTraining!.toJson());
    currentTraining = null;
    isOnTraining = false;
    startTime = null;
    stopTrainingSave();
    notifyListeners();
  }

  void setTrainingInBottomSheet(bool value) {
    isTrainingInBottomSheet = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // -------------------------------- Local save -------------------------------
  // ---------------------------------------------------------------------------

  SharedPreferences? sharedPreferences;

  // Use of shared preferences

  // Initialize shared preferences
  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // Save isOnTraining in shared preferences
  startTrainingSave(bool value, String trainingId, DateTime startTime) async {
    // Get shared preferences instance
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }

    // Save isOnTraining
    sharedPreferences!.setBool('isOnTraining', value);

    // Save current training id
    sharedPreferences!.setString('currentTrainingId', trainingId);
    // Map<String, dynamic> trainingJson = training.toJsonWithoutTimestamp();
    // sharedPreferences!.setString('currentTrainingId', jsonEncode(trainingJson));

    // Save start time
    sharedPreferences!.setInt('startTime', startTime.millisecondsSinceEpoch);
  }

  // Check if the user is currently training
  checkIfIsOnTraining() async {
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }

    // Get isOnTraining
    bool? isOnTraining = sharedPreferences!.getBool('isOnTraining');
    if (isOnTraining == null) {
      return null;
    }

    // Get current training
    String? trainingId = sharedPreferences!.getString('currentTrainingId');

    // Get start time
    int? startTimeStr = sharedPreferences!.getInt('startTime');
    this.isOnTraining = isOnTraining;
    this.startTime = DateTime.fromMillisecondsSinceEpoch(startTimeStr!);
    // Convert json training to Training
    if (trainingId != null) {
      DocumentSnapshot<Object?> training =
          await trainingCollection.doc(trainingId).get();
      this.currentTraining = Training.fromJson(
          training.data() as Map<String, dynamic>, training.id);
      // this.currentTraining = Training.fromJsonWithoutTimestamp(
      //     jsonDecode(training) as Map<String, dynamic>);
    }

    notifyListeners();
    return this.startTime;
  }

  stopTrainingSave() async {
    if (sharedPreferences == null) {
      await initSharedPreferences();
    }
    sharedPreferences!.remove('isOnTraining');
    sharedPreferences!.remove('currentTrainingId');
    sharedPreferences!.remove('startTime');
  }
}
