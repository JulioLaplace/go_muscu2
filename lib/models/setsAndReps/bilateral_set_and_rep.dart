import 'dart:convert';

import 'package:go_muscu2/models/setsAndReps/set_and_rep.dart';

BilateralSetAndRep bilateralSetAndRepFromJson(String str) =>
    BilateralSetAndRep.fromJson(json.decode(str));

String bilateralSetAndRepToJson(BilateralSetAndRep data) =>
    json.encode(data.toJson());

class BilateralSetAndRep extends SetAndRep {
  String repNumber;
  String weight;
  String additionalRepNumber;
  String additionalWeight;

  BilateralSetAndRep({
    required super.setNumber,
    required super.note,
    required this.repNumber,
    required this.weight,
    required this.additionalRepNumber,
    required this.additionalWeight,
  });

  factory BilateralSetAndRep.fromJson(Map<String, dynamic> json) =>
      BilateralSetAndRep(
        setNumber: json["setNumber"] ?? 0,
        note: json["note"].toString(),
        repNumber: json["repNumber"].toString(),
        weight: json["weight"].toString(),
        additionalRepNumber: json["additionalRepNumber"].toString(),
        additionalWeight: json["additionalWeight"].toString(),
      );

  @override
  Map<String, dynamic> toJson() => {
        "setNumber": setNumber,
        "note": note,
        "repNumber": repNumber,
        "weight": weight,
        "additionalRepNumber": additionalRepNumber,
        "additionalWeight": additionalWeight,
      };
}
