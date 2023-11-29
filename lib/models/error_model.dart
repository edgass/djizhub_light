// To parse this JSON data, do
//
//     final errorType = errorTypeFromJson(jsonString);

import 'dart:convert';

ErrorType errorTypeFromJson(String str) => ErrorType.fromJson(json.decode(str));

String errorTypeToJson(ErrorType data) => json.encode(data.toJson());

class ErrorType {
  int? status;
  String? message;
  dynamic data;
  List<Error>? errors;

  ErrorType({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory ErrorType.fromJson(Map<String, dynamic> json) => ErrorType(
    status: json["status"],
    message: json["message"],
    data: json["data"],
    errors: json["errors"] == null ? [] : List<Error>.from(json["errors"]!.map((x) => Error.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x.toJson())),
  };
}

class Error {
  String? property;
  String? message;

  Error({
    this.property,
    this.message,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    property: json["property"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "property": property,
    "message": message,
  };
}
