import 'dart:convert';

SetAndRep setAndRepFromJson(String str) => SetAndRep.fromJson(json.decode(str));

String setAndRepToJson(SetAndRep data) => json.encode(data.toJson());

class SetAndRep {
  int setNumber;
  String note;

  SetAndRep({
    required this.setNumber,
    required this.note,
  });

  factory SetAndRep.fromJson(Map<String, dynamic> json) => SetAndRep(
        setNumber: json["setNumber"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "setNumber": setNumber,
        "note": note,
      };
}
