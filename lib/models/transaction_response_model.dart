import 'dart:convert';

TransactionResponseModel transactionResponseModelFromJson(String str) => TransactionResponseModel.fromJson(json.decode(str));

String transactionResponseModelToJson(TransactionResponseModel data) => json.encode(data.toJson());


class TransactionResponseModel {
  final int? code;
  final String? message;
  final dynamic error;
  final dynamic metadata;
  final Data? data;

  TransactionResponseModel({
    this.code,
    this.message,
    this.error,
    this.metadata,
    this.data,
  });

  factory TransactionResponseModel.fromRawJson(String str) => TransactionResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) => TransactionResponseModel(
    code: json["code"],
    message: json["message"],
    error: json["error"],
    metadata: json["metadata"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "error": error,
    "metadata": metadata,
    "data": data?.toJson(),
  };
}

class Data {
  final String? id;
  final String? type;
  final String? name;
  final String? dataOperator;
  final String? phoneNumber;
  final int? amount;
  final int? fee;
  final int? totalAmount;
  final String? launchUrl;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.type,
    this.name,
    this.dataOperator,
    this.phoneNumber,
    this.amount,
    this.fee,
    this.totalAmount,
    this.launchUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    dataOperator: json["operator"],
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
    "operator": dataOperator,
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
