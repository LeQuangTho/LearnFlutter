import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:dio/dio.dart' as diox;

import '../../configs/application.dart';
import '../../constants/hard_constants.dart';
import '../../constants/http_status_codes.dart';
import '../../helpers/untils/logger.dart';
import '../../helpers/untils/stop_watch.dart';

class BaseRepository {
  var dio = diox.Dio(diox.BaseOptions(
    baseUrl: AppData.baseUrl,
    // connectTimeout: CONNECT_TIME_OUT,
    // receiveTimeout: RECEIVE_TIME_OUT,
  )); // with default Options

  Future<diox.Response<dynamic>> downloadFile(
      String url, String path, Function onReceive,
      {String? accessToken, String? refreshToken}) async {
    var response = await dio.download(
      url,
      path,
      options: getOptions(refreshToken: refreshToken),
      onReceiveProgress: (received, total) {
        onReceive(received, total);
      },
    );
    return response;
  }

  Future<diox.Response<dynamic>> sendFormData(
      String gateway, diox.FormData formData,
      {String? accessToken, String? refreshToken}) async {
    try {
      var response = await dio.post(
        gateway,
        data: formData,
        options: getOptions(refreshToken: refreshToken),
        onSendProgress: (send, total) {},
        onReceiveProgress: (received, total) {},
      );

      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  Future<diox.Response<dynamic>> putFormData(
      String gateway, diox.FormData formData,
      {String? accessToken, String? refreshToken}) async {
    try {
      var response = await dio.put(
        gateway,
        data: formData,
        options:
            getOptions(refreshToken: refreshToken, accessToken: accessToken),
        onSendProgress: (send, total) {},
        onReceiveProgress: (received, total) {},
      );
      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  Future<diox.Response<dynamic>> postRoute(
    String gateway,
    Map<String, dynamic>? body, {
    String? query,
    String? refreshToken,
    String? accessToken,
  }) async {
    try {
      Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }
      var response = AppData.mode == MODE_DEV
          ? await stopWatchApi(
              () => dio.post(
                    gateway,
                    data: convert.jsonEncode(body),
                    options: getOptions(
                        refreshToken: refreshToken, accessToken: accessToken),
                    queryParameters: query == null ? null : paramsObject,
                  ),
              POST,
              gateway)
          : await dio.post(
              gateway,
              data: convert.jsonEncode(body),
              options: getOptions(
                  refreshToken: refreshToken, accessToken: accessToken),
              queryParameters: query == null ? null : paramsObject,
            );
      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  Future<diox.Response<dynamic>> putRoute(
      String gateway, Map<String, dynamic> body,
      {String? accessToken, String? refreshToken}) async {
    try {
      var response = AppData.mode == MODE_DEV
          ? await stopWatchApi(
              () => dio.put(
                    gateway,
                    data: convert.jsonEncode(body),
                    options: getOptions(refreshToken: refreshToken),
                  ),
              PUT,
              gateway)
          : await dio.put(
              gateway,
              data: convert.jsonEncode(body),
              options: getOptions(refreshToken: refreshToken),
            );
      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  Future<diox.Response<dynamic>> patchRoute(String gateway,
      {String? query,
      Map<String, dynamic>? body,
      String? accessToken,
      String? refreshToken}) async {
    try {
      Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      var response = AppData.mode == MODE_DEV
          ? await stopWatchApi(
              () => dio.patch(
                    gateway,
                    data: body == null ? null : convert.jsonEncode(body),
                    options: getOptions(refreshToken: refreshToken),
                    queryParameters: query == null ? null : paramsObject,
                  ),
              PATCH,
              gateway)
          : await dio.patch(
              gateway,
              data: body == null ? null : convert.jsonEncode(body),
              options: getOptions(refreshToken: refreshToken),
              queryParameters: query == null ? null : paramsObject,
            );
      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  Future<diox.Response<dynamic>> getRoute(String gateway,
      {String? params,
      String? query,
      String? accessToken,
      String? refreshToken}) async {
    try {
      Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      var response = AppData.mode == MODE_DEV
          ? await stopWatchApi(
              () => dio.get(
                    gateway,
                    options: getOptions(
                        refreshToken: refreshToken, accessToken: accessToken),
                    queryParameters: query == null ? null : paramsObject,
                  ),
              GET,
              gateway)
          : await dio.get(
              gateway,
              options: getOptions(
                  refreshToken: refreshToken, accessToken: accessToken),
              queryParameters: query == null ? null : paramsObject,
            );
      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  Future<diox.Response<dynamic>> deleteRoute(String gateway,
      {String? params,
      String? query,
      Map<String, dynamic>? body,
      String? accessToken,
      String? refreshToken}) async {
    try {
      Map<String, String> paramsObject = {};
      if (query != null) {
        query.split('&').forEach((element) {
          paramsObject[element.split('=')[0].toString()] =
              element.split('=')[1].toString();
        });
      }

      var response = AppData.mode == MODE_DEV
          ? await stopWatchApi(
              () => dio.delete(
                    gateway,
                    options: getOptions(),
                    queryParameters: query == null ? null : paramsObject,
                  ),
              DELETE,
              gateway)
          : await dio.delete(
              gateway,
              options: getOptions(refreshToken: refreshToken),
              queryParameters: query == null ? null : paramsObject,
            );
      return response;
    } on diox.DioError catch (exception) {
      catchDioError(exception);
      throw Exception(exception.message);
    }
  }

  catchDioError(diox.DioError exception) {
    if (exception.type == diox.DioErrorType.connectTimeout ||
        exception.type == diox.DioErrorType.receiveTimeout) {
      // Application().switchDomainToBackup();
      throw exception;
    }
  }

  diox.Options getOptions({String? accessToken, String? refreshToken}) {
    return diox.Options(
      validateStatus: (status) {
        if ([StatusCode.validateStatus].contains(status)) {
          UtilLogger.log('FETCH ERROR', 'Status code: $status');
        }
        return true;
      },
      headers: getHeaders(refreshToken: refreshToken, accessToken: accessToken),
    );
  }

  getHeaders({String? accessToken, String? refreshToken}) {
    if (refreshToken != null && refreshToken.isNotEmpty) {
      return {'Authorization': 'Bearer ', 'RefreshToken': refreshToken};
    }
    if (accessToken != null && accessToken.isNotEmpty) {
      return {'Authorization': 'Bearer ' + accessToken};
    }
  }

  printEndpoint(String method, String endpoint) {
    print('${method.toUpperCase()}: $endpoint');
  }

  printResponse(diox.Response<dynamic> response) {
    print('StatusCode: ${response.statusCode}');
    print('Body: ${response.data.toString()}');
  }
}

mixin Decodable<T> {
  T decode(dynamic data);
}

class TypeDecodable<T> implements Decodable<TypeDecodable<T>> {
  T value;
  TypeDecodable({required this.value});

  @override
  TypeDecodable<T> decode(dynamic data) {
    value = data;
    return this;
  }
}

// Project imports:

/// A function that creates an object of type [T]
typedef Create<T> = T Function();

/// Construct to get object from generic class
abstract class GenericObject<T> {
  Create<Decodable<dynamic>> create;

  GenericObject({required this.create});

  T genericObject(dynamic data) {
    final item = create();
    return item.decode(data);
  }
}

///Construct to wrap response from API.
///Used it as return object of APIController to handle any kind of response.
class ResponseWrapper<T> extends GenericObject<T> {
  T? response;
  ErrorResponse? error;

  ResponseWrapper({
    required Create<Decodable<dynamic>> create,
    this.error,
  }) : super(create: create);

  factory ResponseWrapper.init({
    required Create<Decodable<dynamic>> create,
    required Map<String, dynamic>? json,
  }) {
    final wrapper = ResponseWrapper<T>(create: create);
    wrapper.error = ErrorResponse.fromMap(json ?? {});
    try {
      wrapper.response = wrapper.genericObject(json);
    } catch (e) {
      return wrapper;
    }
    return wrapper;
  }
}

class APIResponse<T> extends GenericObject<T>
    implements Decodable<APIResponse<T>> {
  int code;
  String message;
  String traceId;
  T? data;

  APIResponse({
    required Create<Decodable<dynamic>> create,
    this.code = 200,
    this.traceId = '',
    this.message = '',
  }) : super(create: create);

  @override
  APIResponse<T> decode(dynamic json) {
    code = json['code'] ?? 0;
    message = json['message'] ?? '';
    traceId = json['traceId'] ?? '';
    data = json['data'] == null ? null : genericObject(json['data']);
    return this;
  }
}

class ErrorResponse implements Exception {
  int code;
  String error;
  String message;
  String version;
  @override
  String toString() {
    return message;
  }

  ErrorResponse({
    this.code = 500,
    this.error = '',
    this.message = '',
    this.version = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'error': error,
      'message': message,
      'version': version,
    };
  }

  factory ErrorResponse.fromMap(Map<String, dynamic> map) {
    return ErrorResponse(
      code: map['code']?.toInt() ?? 0,
      error: map['error'] ?? '',
      message: map['message'] ?? '',
      version: map['version'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorResponse.fromJson(String source) =>
      ErrorResponse.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErrorResponse &&
        other.code == code &&
        other.error == error &&
        other.message == message &&
        other.version == version;
  }

  @override
  int get hashCode {
    return code.hashCode ^ error.hashCode ^ message.hashCode ^ version.hashCode;
  }
}

class NullClass implements Decodable<NullClass> {
  @override
  NullClass decode(data) {
    return this;
  }
}
