import 'dart:convert';

import 'package:go_muscu2/models/setsAndReps/set_and_rep.dart';

UnilateralSetAndRep unilateralSetAndRepFromJson(String str) =>
    UnilateralSetAndRep.fromJson(json.decode(str));

String unilateralSetAndRepToJson(UnilateralSetAndRep data) =>
    json.encode(data.toJson());

class UnilateralSetAndRep extends SetAndRep {
  String repNumberLeft;
  String weightLeft;
  String additionalRepNumberLeft;
  String additionalWeightLeft;
  String repNumberRight;
  String weightRight;
  String additionalRepNumberRight;
  String additionalWeightRight;

  UnilateralSetAndRep({
    required super.setNumber,
    required super.note,
    required this.repNumberLeft,
    required this.weightLeft,
    required this.additionalRepNumberLeft,
    required this.additionalWeightLeft,
    required this.repNumberRight,
    required this.weightRight,
    required this.additionalRepNumberRight,
    required this.additionalWeightRight,
  });

  factory UnilateralSetAndRep.fromJson(Map<String, dynamic> json) =>
      UnilateralSetAndRep(
        setNumber: json["setNumber"],
        note: json["note"],
        repNumberLeft: json["repNumberLeft"].toString(),
        weightLeft: json["weightLeft"].toString(),
        additionalRepNumberLeft: json["additionalRepNumberLeft"].toString(),
        additionalWeightLeft: json["additionalWeightLeft"].toString(),
        repNumberRight: json["repNumberRight"].toString(),
        weightRight: json["weightRight"].toString(),
        additionalRepNumberRight: json["additionalRepNumberRight"].toString(),
        additionalWeightRight: json["additionalWeightRight"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "setNumber": setNumber,
        "note": note,
        "repNumberLeft": repNumberLeft,
        "weightLeft": weightLeft,
        "additionalRepNumberLeft": additionalRepNumberLeft,
        "additionalWeightLeft": additionalWeightLeft,
        "repNumberRight": repNumberRight,
        "weightRight": weightRight,
        "additionalRepNumberRight": additionalRepNumberRight,
        "additionalWeightRight": additionalWeightRight,
      };
}
