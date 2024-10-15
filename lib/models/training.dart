import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_muscu2/models/exercise.dart';

Training trainingFromJson(String str) =>
    Training.fromJson(json.decode(str), '');

String trainingToJson(Training data) => json.encode(data.toJson());

class Training {
  String id;
  String trainingName;
  String trainingCategory;
  DateTime? lastTrainingDate;
  Duration? duration;
  List<Exercise> exercises;

  Training({
    required this.id,
    required this.trainingName,
    required this.trainingCategory,
    required this.exercises,
    this.lastTrainingDate,
    this.duration,
  });

  factory Training.fromJson(Map<String, dynamic> json, String id) => Training(
        id: id,
        trainingName: json["trainingName"],
        trainingCategory: json["trainingCategory"],
        exercises: List<Exercise>.from(json["exercises"].map((exerciseJson) =>
                Exercise.fromJson(exerciseJson, exerciseJson["id"])) ??
            []),
        lastTrainingDate: json["lastTrainingDate"]?.toDate(),
        duration: json["duration"] == null
            ? null
            : Duration(milliseconds: json["duration"]),
      );

  factory Training.fromJsonWithoutTimestamp(Map<String, dynamic> json) =>
      Training(
        id: json["id"],
        trainingName: json["trainingName"],
        trainingCategory: json["trainingCategory"],
        exercises: List<Exercise>.from(json["exercises"].map((exerciseJson) =>
                Exercise.fromJson(exerciseJson, exerciseJson["id"])) ??
            []),
        lastTrainingDate: json["lastTrainingDate"] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["lastTrainingDate"]),
        duration: json["duration"] == null
            ? null
            : Duration(milliseconds: json["duration"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trainingName": trainingName,
        "trainingCategory": trainingCategory,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
        "lastTrainingDate": lastTrainingDate == null
            ? null
            : Timestamp.fromDate(lastTrainingDate!),
        "duration": duration == null ? null : duration!.inMilliseconds,
      };

  Map<String, dynamic> toJsonWithoutTimestamp() => {
        "id": id,
        "trainingName": trainingName,
        "trainingCategory": trainingCategory,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
        "lastTrainingDate": lastTrainingDate == null
            ? null
            : lastTrainingDate!.millisecondsSinceEpoch,
        "duration": duration == null ? null : duration!.inMilliseconds,
      };
}
