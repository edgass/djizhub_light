import 'dart:convert';

NumberListModel numberListFromJson(String str) => NumberListModel.fromJson(json.decode(str));

class NumberListModel {
  int? code;
  String? message;
  dynamic error;
  dynamic metadata;
  List<String>? data;

  NumberListModel({
    this.code,
    this.message,
    this.error,
    this.metadata,
    this.data,
  });

  factory NumberListModel.fromRawJson(String str) => NumberListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());


  factory NumberListModel.fromJson(Map<String, dynamic> json) => NumberListModel(
    code: json["code"],
    message: json["message"],
    error: json["error"],
    metadata: json["metadata"],
    data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "error": error,
    "metadata": metadata,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
