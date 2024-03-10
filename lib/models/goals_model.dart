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
    data: json["data"] == null ? [] : List<Goal>.from(json["data"]!.map((x) => Goal.fromJson(x))),
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
  String? code;
  String? type;
  int? goal;
  int? limit_guest;
  String? name;
  String? description;
  DateTime? dateOfWithdrawal;
  bool? withdrawable;
  bool? listable;
  bool? action_required;
  bool? emmergency_withdrawal;
  int? percent_progress;
  bool? constraint;
  bool? foreign_account;
  int? balance;
  int? min_transaction;
  int? max_transaction;
  int? subscribers;
  String? status;
  List<Transaction>? transactions;
  DateTime? createdAt;
  DateTime? updatedAt;

  Goal({
    this.id,
    this.code,
    this.type,
    this.goal,
    this.limit_guest,
    this.name,
    this.description,
    this.dateOfWithdrawal,
    this.withdrawable,
    this.listable,
    this.action_required,
    this.emmergency_withdrawal,
    this.percent_progress,
    this.constraint,
    this.foreign_account,
    this.balance,
    this.min_transaction,
    this.max_transaction,
    this.subscribers,
    this.status,
    this.transactions,
    this.createdAt,
    this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json["id"],
    code: json["code"],
    type: json["type"],
    goal: json["goal"],
    limit_guest: json["limit_guest"],
    name: json["name"],
    description: json["description"],
    dateOfWithdrawal: json["date_of_withdrawal"] == null ? null : DateTime.parse(json["date_of_withdrawal"]),
    withdrawable: json["withdrawable"],
    listable: json["listable"],
    action_required: json["action_required"],
    emmergency_withdrawal: json["emmergency_withdrawal"],
    percent_progress: json["percent_progress"],
    constraint: json["constraint"],
    foreign_account: json["foreign_account"],
    balance: json["balance"],
    min_transaction: json["min_transaction"],
    max_transaction: json["max_transaction"],
    subscribers: json["subscribers"],
    status: json["status"],
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "type": type,
    "goal": goal,
    "limit_guest": limit_guest,
    "name": name,
    "description": description,
    "date_of_withdrawal": dateOfWithdrawal?.toIso8601String(),
    "withdrawable": withdrawable,
    "listable": listable,
    "action_required": action_required,
    "emmergency_withdrawal": emmergency_withdrawal,
    "percent_progress": percent_progress,
    "constraint": constraint,
    "foreign_account": foreign_account,
    "balance": balance,
    "min_transaction": min_transaction,
    "max_transaction": max_transaction,
    "subscribers": subscribers,
    "status": status,
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Transaction {
  String? id;
  String? type;
  String? name;
  String? note;
  bool? secret;
  bool? validation_required;
  String? transactionOperator;
  int? amount;
  int? fee;
  String? status;
  String? partner_id;
  String? phone_number;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Validator>? validators;

  Transaction({
    this.id,
    this.type,
    this.name,
    this.note,
    this.secret,
    this.validation_required,
    this.transactionOperator,
    this.amount,
    this.fee,
    this.status,
    this.partner_id,
    this.phone_number,
    this.createdAt,
    this.updatedAt,
    this.validators,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    note: json["note"],
    secret: json["secret"],
    validation_required: json["validation_required"],
    transactionOperator: json["operator"],
    amount: json["amount"],
    fee: json["fee"],
    status: json["status"],
    partner_id: json["partner_id"],
    phone_number: json["phone_number"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    validators: json["validators"] == null ? [] : List<Validator>.from(json["validators"]!.map((x) => Validator.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "note": note,
    "secret": secret,
    "validation_required": validation_required,
    "operator": transactionOperator,
    "amount": amount,
    "fee": fee,
    "status": status,
    "partner_id": partner_id,
    "phone_number": phone_number,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "validators": validators == null ? [] : List<dynamic>.from(validators!.map((x) => x.toJson())),
  };
}

class Validator {
  String? name;
  String? phoneNumber;
  String? status;

  Validator({
    this.name,
    this.phoneNumber,
    this.status,
  });

  factory Validator.fromRawJson(String str) => Validator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Validator.fromJson(Map<String, dynamic> json) => Validator(
    name: json["name"],
    phoneNumber: json["phone_number"],
    status: json["status"]!,
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phone_number": phoneNumber,
    "status": status,
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
