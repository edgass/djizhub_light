// To parse this JSON data, do
//
//     final goals = goalsFromJson(jsonString);

import 'dart:convert';

Goals goalsFromJson(String str) => Goals.fromJson(json.decode(str));
Goal goalFromJson(String str) => Goal.fromJson(json.decode(str));

String goalsToJson(Goals data) => json.encode(data.toJson());

class Goals {
  int? code;
  String? message;
  dynamic error;
  Metadata? metadata;
  List<Goal>? data;

  Goals({
    this.code,
    this.message,
    this.error,
    this.metadata,
    this.data,
  });

  factory Goals.fromJson(Map<String, dynamic> json) => Goals(
    code: json["code"],
    message: json["message"],
    error: json["error"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
   // data: json["data"] == null ? [] : List<Goal>.from(json["data"]!.map((x) => Goal.fromJson(x))),
    data: json["data"] is List ? List<Goal>.from((json["data"] as List).map((x) => Goal.fromJson(x))) : [],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "error": error,
    "metadata": metadata?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Goal {
  String? id;
  String? name;
  String? description;
  int? goal;
  DateTime? dateOfWithdrawal;
  bool? constraint;
  List<Transaction>? transactions;
  int? balance;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Goal({
    this.id,
    this.name,
    this.description,
    this.goal,
    this.dateOfWithdrawal,
    this.constraint,
    this.transactions,
    this.balance,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    goal: json["goal"],
    dateOfWithdrawal: json["date_of_withdrawal"] == null ? null : DateTime.parse(json["date_of_withdrawal"]),
    constraint: json["constraint"],
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    balance: json["balance"],
    status: json["status"],
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
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "balance": balance,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Transaction {
  String? id;
  String? type;
  String? transactionOperator;
  int? amount;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Transaction({
    this.id,
    this.type,
    this.transactionOperator,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    type: json["type"],
    transactionOperator: json["operator"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "operator": transactionOperator,
    "amount": amount,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Metadata {
  int? totalElements;
  int? page;

  Metadata({
    this.totalElements,
    this.page,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
    totalElements: json["total_elements"],
    page: json["page"],
  );

  Map<String, dynamic> toJson() => {
    "total_elements": totalElements,
    "page": page,
  };
}
