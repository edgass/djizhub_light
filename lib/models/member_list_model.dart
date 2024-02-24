import 'dart:convert';

import 'goals_model.dart';



SingleMember singleMemberFromJson(String str) => SingleMember.fromJson(json.decode(str));
MemberListModel memberListModelFromJson(String str) => MemberListModel.fromJson(json.decode(str));
class MemberListModel {
  int? code;
  String? message;
  dynamic error;
  dynamic metadata;
  List<SingleMember>? data;


  MemberListModel({
    this.code,
    this.message,
    this.error,
    this.metadata,
    this.data,
  });

  factory MemberListModel.fromRawJson(String str) => MemberListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MemberListModel.fromJson(Map<String, dynamic> json) => MemberListModel(
    code: json["code"],
    message: json["message"],
    error: json["error"],
    metadata: json["metadata"],
    data: json["data"] == null ? [] : List<SingleMember>.from(json["data"]!.map((x) => SingleMember.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "error": error,
    "metadata": metadata,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SingleMember {
  String? id;
  String? name;
  int? count;
  int? total;
  List<Transaction>? transactions;
  DateTime? createdAt;
  bool? deleted;
  bool? out;

  SingleMember({
    this.id,
    this.name,
    this.count,
    this.total,
    this.transactions,
    this.createdAt,
    this.deleted,
    this.out,
  });

  factory SingleMember.fromRawJson(String str) => SingleMember.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());



  factory SingleMember.fromJson(Map<String, dynamic> json) => SingleMember(
    id: json["id"],
    name: json["name"],
    count: json["count"],
    total: json["total"],
    transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    deleted: json["deleted"],
    out: json["out"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "count": count,
    "total": total,
    "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
    "created_at": createdAt?.toIso8601String(),
    "deleted": deleted,
    "out": out,
  };
}
/*
class Transaction {
  String? id;
  String? type;
  String? name;
  String? transactionOperator;
  String? phoneNumber;
  int? amount;
  int? fee;
  int? totalAmount;
  String? launchUrl;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Transaction({
    this.id,
    this.type,
    this.name,
    this.transactionOperator,
    this.phoneNumber,
    this.amount,
    this.fee,
    this.totalAmount,
    this.launchUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Transaction.fromRawJson(String str) => Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    transactionOperator: json["operator"],
    phoneNumber: json["phone_number"],
    amount: json["amount"],
    fee: json["fee"],
    totalAmount: json["total_amount"],
    launchUrl: json["launch_url"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "operator": transactionOperator,
    "phone_number": phoneNumber,
    "amount": amount,
    "fee": fee,
    "total_amount": totalAmount,
    "launch_url": launchUrl,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
*/