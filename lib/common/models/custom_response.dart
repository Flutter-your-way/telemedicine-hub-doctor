import 'dart:convert';

class CustomResponse {
  bool success;
  String msg;
  dynamic data;
  int code;
  CustomResponse({
    required this.success,
    required this.msg,
    required this.code,
    this.data,
  });

  @override
  String toString() {
    return jsonEncode({
      "success": success,
      "msg": msg,
      "statusCode": code,
      "data": "$data",
    });
  }
}
