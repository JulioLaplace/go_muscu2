import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_muscu2/models/setsAndReps/bilateral_set_and_rep.dart';
import 'package:go_muscu2/models/setsAndReps/set_and_rep.dart';
import 'package:go_muscu2/models/setsAndReps/unilateral_set_and_rep.dart';

ExerciseData exerciseDataFromJson(String str) =>
    ExerciseData.fromJson(json.decode(str), '');

String exerciseDataToJson(ExerciseData data) => json.encode(data.toJson());

class ExerciseData {
  String id;
  DateTime date;
  List<SetAndRep> setsAndReps;

  ExerciseData({
    required this.id,
    required this.date,
    required this.setsAndReps,
  });

  // SetAndRep is either BilateralSetAndRep or UnilateralSetAndRep
  factory ExerciseData.fromJson(Map<String, dynamic> json, String id) {
    List<dynamic> setsAndRepsJson = json["setsAndReps"];
    List<SetAndRep> setsAndReps = [];
    for (var element in setsAndRepsJson) {
      if (element.containsKey("repNumber")) {
        setsAndReps.add(BilateralSetAndRep.fromJson(element));
      } else if (element.containsKey("repNumberLeft")) {
        setsAndReps.add(UnilateralSetAndRep.fromJson(element));
      }
    }
    return ExerciseData(
      id: id,
      date: json["date"]?.toDate(),
      setsAndReps: setsAndReps,
    );
  }

  factory ExerciseData.fromJsonWithoutTimestamp(Map<String, dynamic> json) {
    List<dynamic> setsAndRepsJson = json["setsAndReps"];
    List<SetAndRep> setsAndReps = [];
    for (var element in setsAndRepsJson) {
      if (element.containsKey("repNumber")) {
        setsAndReps.add(BilateralSetAndRep.fromJson(element));
      } else if (element.containsKey("repNumberLeft")) {
        setsAndReps.add(UnilateralSetAndRep.fromJson(element));
      }
    }
    return ExerciseData(
      id: json["id"],
      date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
      setsAndReps: setsAndReps,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": Timestamp.fromDate(date),
        "setsAndReps": List<dynamic>.from(setsAndReps.map((x) => x.toJson())),
      };

  Map<String, dynamic> toJsonWithoutTimestamp() => {
        "id": id,
        "date": date.millisecondsSinceEpoch,
        "setsAndReps": List<dynamic>.from(setsAndReps.map((x) => x.toJson())),
      };
}
