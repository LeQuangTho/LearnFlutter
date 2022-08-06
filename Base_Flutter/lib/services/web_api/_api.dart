import 'dart:convert';

import 'package:base_flutter/core/models/_response.dart' as api_res;
import 'package:base_flutter/core/utils/configs.dart';
import 'package:dio/dio.dart';

class Api {
  var options = BaseOptions(
    baseUrl: host,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  late Dio dio;
  String? token;

  Api() {
    dio = Dio(options);
  }

  setToken(String bearerToken) async {
    token = bearerToken;
    return;
  }

  api_res.Response castRes(Response res) {
    Map<String, dynamic> json = jsonDecode(res.toString());
    return api_res.Response.fromJson(json);
  }
}
