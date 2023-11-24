// To parse this JSON data, do
//
//     final goals = goalsFromJson(jsonString);

import 'dart:convert';

List<Goals> goalsFromJson(String str) => List<Goals>.from(json.decode(str).map((x) => Goals.fromJson(x)));

String goalsToJson(List<Goals> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Goals {
  String? id;
  String? name;
  String? description;
  int? goal;
  DateTime? dateOfWithdrawal;
  bool? constraint;
  DateTime? createdAt;
  DateTime? updatedAt;

  Goals({
    this.id,
    this.name,
    this.description,
    this.goal,
    this.dateOfWithdrawal,
    this.constraint,
    this.createdAt,
    this.updatedAt,
  });

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    goal: json["goal"],
    dateOfWithdrawal: json["date_of_withdrawal"] == null ? null : DateTime.parse(json["date_of_withdrawal"]),
    constraint: json["constraint"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "goal": goal,
    "date_of_withdrawal": dateOfWithdrawal?.toIso8601String(),
    "constraint": constraint,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
