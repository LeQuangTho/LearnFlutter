import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../BLOC/app_blocs.dart';
import '../../BLOC/authentication/models/login/login_result.dart';
import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../configs/application.dart';
import '../../navigations/app_pages.dart';
import '../../navigations/app_routes.dart';

class BaseDio {
  static final BaseOptions _options = BaseOptions(
    baseUrl: AppData.baseUrl,
    connectTimeout: 20000,
    receiveTimeout: 20000,
    followRedirects: false,
    validateStatus: (status) {
      if (status == 401) {
        return false;
      }
      return true;
    },
  );

  static final Dio _dio = Dio(_options);

  BaseDio._internal() {
    _dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 1000),
    );
    _dio.interceptors.add(ResponseInterceptor());
  }

  static final BaseDio instance = BaseDio._internal();

  Dio get dio => _dio;
}

class ResponseInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    super.onError(err, handler);
    if (err.type == DioErrorType.response) {
      if (err.response!.statusCode == 401) {
        if (AppBlocs.authenticationBloc.loginResponseData !=
            LoginResponseData.empty) {
          DateTime startTime = DateTime.now();
          if (AppBlocs.authenticationBloc.loginResponseData.expiresTime
                  ?.isNotEmpty ??
              false) {
            DateTime expiresTime = DateFormat("MM/dd/yyyy hh:mm:ss").parse(
                AppBlocs.authenticationBloc.loginResponseData.expiresTime!);

            if (startTime.compareTo(expiresTime) == 0) {
              print("Both date time are at same moment.");
            }

            if (startTime.compareTo(expiresTime) < 0) {
              print("startTime is before expiresTime");
            }

            if (startTime.compareTo(expiresTime) > 0) {
              /// hết hạn token
              print("startTime is after expiresTime");
              AppNavigator.pushNamedAndRemoveUntil(Routes.LOGIN);
              // showToast(ToastType.error, title: "Phiên đăng nhập hết hạn");
              showDialogBio(
                  title: "Thời gian chờ phiên",
                  body: "Đã hết thời gian truy cập ứng dụng. Vì lý do bảo mật, Bạn vui lòng thực hiện đăng nhập lại");
            }
          }
        }
      } else if (err.response!.statusCode == 400) {
        handler.resolve(err.response!);
      } else if (err.response!.statusCode == 500) {
        handler.resolve(err.response!);
      }
    } else if (err.type == DioErrorType.connectTimeout) {
      showToast(ToastType.error,
          title: "Không thể kết nối tới máy chủ, vui lòng thử lại");
    } else if (err.type == DioErrorType.receiveTimeout) {
      showToast(ToastType.error, title: "Kết nối mạng kém,vui lòng thử lại");
    } else {
      showToast(ToastType.error,
          title: "Không có kết nối internet, vui lòng kiểm tra lại");
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      print("ádasdsa");
      handler.resolve(response);
    } else {
      handler.next(response);
    }
  }
}
