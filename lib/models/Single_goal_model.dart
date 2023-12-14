// To parse this JSON data, do
//
//     final singleGoals = singleGoalsFromJson(jsonString);

import 'dart:convert';

import 'goals_model.dart';

SingleGoals singleGoalsFromJson(String str) => SingleGoals.fromJson(json.decode(str));

String singleGoalsToJson(SingleGoals data) => json.encode(data.toJson());

class SingleGoals {
  int? code;
  String? message;
  dynamic error;
  dynamic metadata;
  Goal? data;

  SingleGoals({
    this.code,
    this.message,
    this.error,
    this.metadata,
    this.data,
  });

  factory SingleGoals.fromJson(Map<String, dynamic> json) => SingleGoals(
    code: json["code"],
    message: json["message"],
    error: json["error"],
    metadata: json["metadata"],
    data: json["data"] == null ? null : Goal.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "error": error,
    "metadata": metadata,
    "data": data?.toJson(),
  };
}
class Transaction {
  String? id;
  Type? type;
  Operator? transactionOperator;
  int? amount;
  int? fee;
  Status? status;
  Status? partner_id;
  Status? phone_number;
  DateTime? createdAt;
  DateTime? updatedAt;

  Transaction({
    this.id,
    this.type,
    this.transactionOperator,
    this.amount,
    this.fee,
    this.status,
    this.partner_id,
    this.phone_number,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    type: typeValues.map[json["type"]]!,
    transactionOperator: operatorValues.map[json["operator"]]!,
    amount: json["amount"],
    fee: json["fee"],
    status: statusValues.map[json["status"]]!,
    partner_id: statusValues.map[json["partner_id"]]!,
    phone_number: statusValues.map[json["phone_number"]]!,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": typeValues.reverse[type],
    "operator": operatorValues.reverse[transactionOperator],
    "amount": amount,
    "fee": fee,
    "status": statusValues.reverse[status],
    "partner_id": statusValues.reverse[partner_id],
    "phone_number": statusValues.reverse[phone_number],
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

enum Status {
  PENDING
}

final statusValues = EnumValues({
  "PENDING": Status.PENDING
});

enum Operator {
  OM,
  WAVE
}

final operatorValues = EnumValues({
  "OM": Operator.OM,
  "WAVE": Operator.WAVE
});

enum Type {
  DEPOSIT
}

final typeValues = EnumValues({
  "DEPOSIT": Type.DEPOSIT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
