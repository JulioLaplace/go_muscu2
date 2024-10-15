// parameters
// id : String
// exerciseName : String
// exerciseCategory : String
// unilateral : bool
// image : String
// dataString : List<String> // List of ids of exerciseData
// data : List<ExerciseData>

// JSON format :
// {
//   "id" : "",
//   "exerciseName" : "",
//   "exerciseCategory" : "",
//   "unilateral" : false,
//   "image" : "",
//   "dataString" : [],
//   "data" : []
// }

// To parse this JSON data, do
//
//     final exercise = exerciseFromJson(jsonString);

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_muscu2/models/exercise_data.dart';

Exercise exerciseFromJson(String str) =>
    Exercise.fromJson(json.decode(str), '');

String exerciseToJson(Exercise data) => json.encode(data.toJson());

class Exercise {
  String id;
  String exerciseName;
  String exerciseCategory;
  bool unilateral;
  String setNumberGoal;
  String repNumberGoal;
  String note;
  String image;
  // Contains the id of the exerciseData
  List<ExerciseDataString> dataString;
  // Contains the exerciseData
  List<ExerciseData> data;

  Exercise({
    required this.id,
    required this.exerciseName,
    required this.exerciseCategory,
    required this.unilateral,
    required this.setNumberGoal,
    required this.repNumberGoal,
    this.note = '',
    this.image = '',
    required this.dataString,
    required this.data,
  });

  factory Exercise.fromJson(Map<String, dynamic> json, String id) => Exercise(
        id: id,
        exerciseName: json["exerciseName"],
        exerciseCategory: json["exerciseCategory"],
        unilateral: json["unilateral"],
        setNumberGoal: json["setNumberGoal"].toString(),
        repNumberGoal: json["repNumberGoal"].toString(),
        note: json["note"],
        image: json["image"],
        dataString: List<ExerciseDataString>.from(json["dataString"]
            .map((x) => ExerciseDataString.fromJson(x, x["id"]))),
        data: [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "exerciseName": exerciseName,
        "exerciseCategory": exerciseCategory,
        "unilateral": unilateral,
        "setNumberGoal": setNumberGoal,
        "repNumberGoal": repNumberGoal,
        "note": note,
        "image": image,
        "dataString":
            List<dynamic>.from(dataString.map((x) => x.toJson())) ?? [],
        "data": [],
      };
}

class ExerciseDataString {
  // contains the id of the exerciseData and the date
  String id;
  DateTime date;

  ExerciseDataString({
    required this.id,
    required this.date,
  });

  factory ExerciseDataString.fromJson(Map<String, dynamic> json, String id) =>
      ExerciseDataString(
        id: id,
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": Timestamp.fromDate(date),
      };
}

// class ExerciseData {
//   String id;
//   String exerciseId;
//   DateTime date;
//   List<int> setNumber;
//   List<double> repNumber;
//   List<double> weight;

//   ExerciseData({
//     required this.id,
//     required this.exerciseId,
//     required this.date,
//     required this.setNumber,
//     required this.repNumber,
//     required this.weight,
//   });

//   factory ExerciseData.fromJson(Map<String, dynamic> json, String id) =>
//       ExerciseData(
//         id: id,
//         exerciseId: json["exerciseId"],
//         date: json["date"].toDate(),
//         setNumber: List<int>.from(json["setNumber"]),
//         // as the repNumber is a list of double and sometimes int, we need to convert it to a list of double
//         repNumber:
//             List<double>.from(json["repNumber"].map((x) => x.toDouble())),
//         weight: List<double>.from(json["weight"].map((x) => x.toDouble())),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "exerciseId": exerciseId,
//         "date": Timestamp.fromDate(date),
//         "setNumber": setNumber,
//         "repNumber": repNumber,
//         "weight": weight,
//       };
// }
