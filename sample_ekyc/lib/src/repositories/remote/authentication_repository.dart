import 'package:dio/dio.dart';

import '../../BLOC/app_blocs.dart';
import '../../BLOC/authentication/models/add_firebase/add_firebase_reponse.dart';
import '../../BLOC/authentication/models/create_password/create_password_form2.dart';
import '../../BLOC/authentication/models/login/login_result.dart';
import '../../BLOC/user_remote/models/forms/esign_get_proposal_form.dart';
import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../base_model/api_response.dart';
import '../../configs/application.dart';
import '../../constants/endpoints.dart';
import '../../constants/http_status_codes.dart';
import '../../helpers/firebase_helper.dart';
import '../../helpers/geolocator_helper.dart';
import '../../helpers/untils/logger.dart';
import '../../navigations/app_pages.dart';
import '../local/user_local_repository.dart';
import 'base_dio.dart';

class AuthenticationRepository {
  static Future<ApiResponse<bool>> changeFirstPassword(
      {required CreatePasswordForm2 createPasswordForm}) async {
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final body = createPasswordForm.toJson();
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.changeFirstPassword,
      data: body,
      options: Options(
        headers: {'Authorization': 'Bearer ' + _accessToken},
      ),
    );
    return ApiResponse.fromJson(response.data);
  }

  static Future<bool> activeDevice(
      {required String deviceName, required String deviceId}) async {
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.activeDevice,
      data: {"deviceId": deviceId, "deviceName": deviceName},
      options: Options(
        headers: {'Authorization': 'Bearer ' + _accessToken},
      ),
    );
    return response.statusCode == StatusCode.OK;
  }

  static Future<ApiResponse<bool>> changePassword(
      {required CreatePasswordForm2 createPasswordForm}) async {
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final body = createPasswordForm.toJson();
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.changePassword,
      data: body,
      options: Options(
        headers: {'Authorization': 'Bearer ' + _accessToken},
      ),
    );
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse<bool>> getOTPchangeFirstPass() async {
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.getOtpChangePass,
        options: Options(headers: {'Authorization': 'Bearer ' + _accessToken}));
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse<bool>> getOTP() async {
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.getOtp,
        data: {},
        options: Options(headers: {'Authorization': 'Bearer ' + _accessToken}));
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse<bool>> getOTPForgotPass(
      {required String phoneNumber}) async {
    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.getOtpForgotPass,
        data: {'phoneNumber': phoneNumber});
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse<bool>> verifyOTPForgotPass(
      {required String otp, required String phoneNumber}) async {
    final Response response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.verifyOtpForgotPass,
      data: {"otp": otp, "phoneNumber": phoneNumber},
    );
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse<bool>> verifyOTPs({required String otp}) async {
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.verifyOtp,
        data: {"otp": otp},
        options: Options(headers: {'Authorization': 'Bearer ' + _accessToken}));
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse<bool>> changePassForgotPass(
      {required String otp,
      required String phoneNumber,
      required String newPassword}) async {
    final Response response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.changePassForgotPass,
      data: {
        "phoneNumber": phoneNumber,
        "newPassword": newPassword,
        "otp": otp
      },
    );
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse> getSmartOTP() async {
    showDialogLoading();
    final String? firebaseToken = await FirebaseHelper().getToken();
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final String? _userId = AppBlocs.userRemoteBloc.userResponseDataEntry.id;
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.getSmartOTP,
      data: {"userId": _userId, "firebaseToken": firebaseToken},
      options: Options(
        headers: {'Authorization': 'Bearer ' + _accessToken},
      ),
    );
    AppNavigator.pop();
    return ApiResponse.fromJson(response.data);
  }

  static Future<ApiResponse> verifySmartOTP({required String otp}) async {
    showDialogLoading();
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final String? _userId = AppBlocs.userRemoteBloc.userResponseDataEntry.id;
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.verifySmartOTP,
      data: {"userId": _userId, "otp": otp},
      options: Options(
        headers: {'Authorization': 'Bearer ' + _accessToken},
      ),
    );
    AppNavigator.pop();
    return ApiResponse.fromJson(response.data);
  }

  static Future<bool> checkCurrentPassword(String pass) async {
    showDialogLoading();
    final String _accessToken = await UserLocalRepository().getAccessToken();
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.checkCurrentPassword,
      data: {'password': pass},
      options: Options(
        headers: {'Authorization': 'Bearer ' + _accessToken},
      ),
    );
    AppNavigator.pop();
    return response.data['data'];
  }

  static Future<LoginResponse?> login(
      {required String username,
      required String password,
      required bool remember}) async {
    Map<dynamic, dynamic> deviceInfor =
        await UserLocalRepository().getDeviceInfor();
    var body = {
      "username": username,
      "password": password,
      "remember": remember,
      "device_info": deviceInfor,
    };
    final response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.login,
      data: body,
    );

    return LoginResponse.fromJson(response.data);
  }

  static Future<AddFirebaseReponse?> addFirebaseTokenEnableLocation(
      String accessToken) async {
    showDialogLoading();
    Map<dynamic, dynamic> deviceInfor =
        await UserLocalRepository().getDeviceInfor();
    await GeolocatorHelper().getCurrentPosition().then((location) async {
      if (location != null) {
        final String? firebaseToken = await FirebaseHelper().getToken();
        var body = {
          "deviceId": deviceInfor['device_id'],
          "firebaseToken": firebaseToken,
          "location": location.toMap(),
          "device_info": deviceInfor,
        };
        UtilLogger.log('>>> Add Firebase Token', "$body");
        final response = await BaseDio.instance.dio.post(
            AppData.baseUrl + Endpoints.addFirebaseToken,
            data: body,
            options:
                Options(headers: {'Authorization': 'Bearer ' + accessToken}));
        if (response.statusCode == StatusCode.OK) {
          AppNavigator.pop();
          return AddFirebaseReponse.fromJson(response.data);
        } else {
          return null;
        }
      }
    });
    return null;
  }

  static Future<AddFirebaseReponse?> addFirebaseTokenDisableLocation(
      String accessToken) async {
    Map<dynamic, dynamic> deviceInfor =
        await UserLocalRepository().getDeviceInfor();
    final String? firebaseToken = await FirebaseHelper().getToken();
    var body = {
      "deviceId": deviceInfor['device_id'],
      "firebaseToken": firebaseToken,
      "location": ESignLocation(
        geoLocation: "",
        latitude: 0,
        longitude: 0,
      ).toMap(),
      "device_info": deviceInfor,
    };
    final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.addFirebaseToken,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}));
    if (response.statusCode == StatusCode.OK) {
      return AddFirebaseReponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  static Future<bool> checkUserExist({required String phone}) async {
    Response? response;
    response = await BaseDio.instance.dio.get(
      AppData.baseUrl + Endpoints.checkUserExist + phone,
    );
    return response.statusCode == StatusCode.OK;
  }

  static Future<bool> resetTempPassword(
      {required String phone, required String accessToken}) async {
    Response? response;
    response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.resetTempPassword,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
        data: {});
    return response.statusCode == StatusCode.OK;
  }

  static Future<bool> logOut({required String refreshToken}) async {
    final Map<dynamic, dynamic> deviceInfor =
        await UserLocalRepository().getDeviceInfor();
    final String deviceId = deviceInfor["device_id"];
    final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.logOut,
        data: {"deviceId": deviceId},
        options: Options(headers: {'Authorization': 'Bearer ' + refreshToken}));
    return response.statusCode == StatusCode.OK;
  }
}
