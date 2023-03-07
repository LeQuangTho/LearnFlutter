import 'package:dio/dio.dart';

import '../../BLOC/user_remote/models/response/digital_certificate_response.dart';
import '../../BLOC/user_remote/models/response/manager_device_response.dart';
import '../../BLOC/app_blocs.dart';
import '../../BLOC/user_remote/models/check_signature_response/check_signature_response.dart';
import '../../BLOC/user_remote/models/forms/esign_confirm_signing_form.dart';
import '../../BLOC/user_remote/models/forms/esign_request_signing_form.dart';
import '../../BLOC/user_remote/models/response/contract_detail_response.dart';
import '../../BLOC/user_remote/models/response/contract_item_response.dart';
import '../../BLOC/user_remote/models/response/contract_status_response.dart';
import '../../BLOC/user_remote/models/response/detail_cts_model.dart';
import '../../BLOC/user_remote/models/response/e_contract_count_response.dart';
import '../../BLOC/user_remote/models/response/esign_confirm_signed_efile.dart';
import '../../BLOC/user_remote/models/response/esign_request_signing_response.dart';
import '../../BLOC/user_remote/models/response/notification_data.dart';
import '../../BLOC/user_remote/models/response/user_infor_response.dart';
import '../../base_model/api_response.dart';
import '../../configs/application.dart';
import '../../constants/endpoints.dart';
import '../../constants/http_status_codes.dart';
import '../../helpers/device_infor_helper.dart';
import '../../helpers/firebase_helper.dart';
import '../../helpers/geolocator_helper.dart';
import '../local/user_local_repository.dart';
import 'base_dio.dart';

class UserRemoteRepo {
  static Future<UserInforResponse?> getUserProfile() async {
    final accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.get(
          AppData.baseUrl + Endpoints.userInfor,
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
      if (response.statusCode == StatusCode.OK) {
        return UserInforResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ManagerDeviceResponse?> getListDevices() async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.get(
        AppData.baseUrl + Endpoints.listDevice,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
        // queryParameters: {"isSign": isSign},
      );

      if (response.statusCode == StatusCode.OK) {
        return ManagerDeviceResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<NotificationData>?> getListNotification() async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final response = await BaseDio.instance.dio.get(
      AppData.baseUrl + Endpoints.listNotification,
      options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      // queryParameters: {"isSign": isSign},
    );

    List<NotificationData> list = [];

    if (response.statusCode == StatusCode.OK) {
      for (var responseBody in response.data['data']) {
        NotificationData data = NotificationData.fromJson(responseBody);

        list.add(data);
      }
      return list;
    }
    return list;
  }

  static Future<bool> readNotification({required String notificationId}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.readNotification,
        data: {
          "notifyId": notificationId,
          "userId": AppBlocs.userRemoteBloc.userResponseDataEntry.id,
        },
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      );
      return response.statusCode == StatusCode.OK;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> cancelDevice({required String deviceId}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.cancelDevice,
        data: {
          "deviceId": deviceId,
          "userId": AppBlocs.userRemoteBloc.userResponseDataEntry.id,
        },
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      );
      return response.statusCode == StatusCode.OK;
    } catch (e) {
      return false;
    }
  }

  static Future<EContractCountResponse?> getCountContract() async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.get(
        AppData.baseUrl + Endpoints.countContract,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
        // queryParameters: {"isSign": isSign},
      );

      if (response.statusCode == StatusCode.OK) {
        return EContractCountResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ContractStatusResponse?> getListStatusContract() async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.get(
        AppData.baseUrl + Endpoints.listStatusContract,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
        // queryParameters: {"isSign": isSign},
      );
      if (response.statusCode == StatusCode.OK) {
        return ContractStatusResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<DigitalCertificateResponse?> getListDigitalCertificate(
      [bool? status]) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.listDigitalCertificate,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
        data: {'status': status ?? false},
      );
      if (response.statusCode == StatusCode.OK) {
        return DigitalCertificateResponse.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> refuseSign(
      {required String documentId, required String reason}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final String? _userId =
        await AppBlocs.userRemoteBloc.userResponseDataEntry.id;
    try {
      final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.refuseSign,
        data: {
          "documentId": documentId,
          "userId": _userId,
          "rejectReason": reason,
        },
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      );
      return response.statusCode == StatusCode.OK;
    } catch (e) {
      return false;
    }
  }

  static Future<ContractResponseData?> getListContract(
      {required int type,
      required int pageSize,
      required int pageNumbe}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    try {
      final response = await BaseDio.instance.dio.post(
          AppData.baseUrl + Endpoints.listContract,
          options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
          data: {
            "PageSize": pageSize,
            "PageNumber": pageNumbe,
            "Status": type,
          });

      if (response.statusCode == StatusCode.OK) {
        return ContractResponseData.fromJson(response.data['data']);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<ContractDetailResponse?> getDetailContract(
      {required String idDocument}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final response = await BaseDio.instance.dio.get(
      AppData.baseUrl + Endpoints.detailContract + idDocument,
      options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
    );

    if (response.statusCode == StatusCode.OK) {
      return ContractDetailResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  static Future<ESignRequestSigningResponse?> requestSignEFile(
      {required String userConnectId,
      required String documentCode,
      required String documentId,
      required String signatureBase64}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final ESignRequestDeviceInfo? deviceInfo =
        await DeviceInforHelper().getDeviceInforForRequestSigning();
    final ESignRequestSigningFormLocation? location =
        await GeolocatorHelper().getCurrentPositionForRequestSigning();
    final String? firebaseToken = await FirebaseHelper().getToken();
    final String? userId =
        await AppBlocs.userRemoteBloc.userResponseDataEntry.id;
    print("FIREBASE TOKEN");
    print(firebaseToken);
    print("------");

    final ESignRequestSigningForm form = ESignRequestSigningForm(
      userConnectId: userConnectId,
      userId: userId!,
      imageBase64: signatureBase64,
      documentCode: documentCode,
      documentId: documentId,
      // signatureBase64: signatureBase64,
      location: location!,
      // firebaseToken: firebaseToken!,
      deviceInfo: deviceInfo!,
    );
    print(
      form.toJson(),
    );
    final Response response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.requestSign,
      options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      data: form.toJson(),
    );
    print(response.data.toString());

    if (response.statusCode == StatusCode.OK) {
      return ESignRequestSigningResponse.fromMap(response.data);
    } else {
      return null;
    }
  }

  static Future<ESignRequestSigningResponse?> signEForm(
      {required String userConnectId,
      required String documentCode,
      required String documentId,
      required String signatureBase64}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final ESignRequestDeviceInfo? deviceInfo =
        await DeviceInforHelper().getDeviceInforForRequestSigning();
    final ESignRequestSigningFormLocation? location =
        await GeolocatorHelper().getCurrentPositionForRequestSigning();
    final String? userId =
        await AppBlocs.userRemoteBloc.userResponseDataEntry.id;

    final ESignRequestSigningForm form = ESignRequestSigningForm(
      userConnectId: userConnectId,
      userId: userId!,
      imageBase64: signatureBase64,
      documentCode: documentCode,
      documentId: documentId,
      // signatureBase64: signatureBase64,
      location: location!,
      // firebaseToken: firebaseToken!,
      deviceInfo: deviceInfo!,
    );

    final Response response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.signEForm,
      options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      data: form.toJson(),
    );

    if (response.statusCode == StatusCode.OK) {
      return ESignRequestSigningResponse.fromMap(response.data);
    } else {
      return null;
    }
  }

  static Future<ConfirmSigningEFileResponse?> confirmSignEFile({
    required ConfirmSigningEFileForm form,
    // required String documentCode
  }) async {
    final String accessToken = await UserLocalRepository().getAccessToken();

    final Response response = await BaseDio.instance.dio.post(
      AppData.baseUrl + Endpoints.confirmSign,
      options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
      data: form.toJson(),
    );

    if (response.statusCode == StatusCode.OK) {
      return ConfirmSigningEFileResponse.fromMap(response.data);
    } else {
      if (response.data is Map<dynamic, dynamic> &&
          response.data["data"] == null) {
        response.data["data"] = false;
        return ConfirmSigningEFileResponse.fromMap(response.data);
      }
      return null;
    }
  }

  // DEV mode sửa response model trả về

  static Future<bool> updateProfile(
      {required UserResponseDataEntry userInfo}) async {
    try {
      final String accessToken = await UserLocalRepository().getAccessToken();

      final Response response = await BaseDio.instance.dio.post(
          AppData.baseUrl + Endpoints.updateProfile,
          data: userInfo.toJson(),
          options:
              Options(headers: {'Authorization': 'Bearer ' + accessToken}));
      return response.statusCode == StatusCode.OK;
    } catch (e) {
      return false;
    }
  }

  static Future<ApiResponse<DetailCtsModel>> getDetailCTS(
      {required String? idCTS}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final response = await BaseDio.instance.dio.get(
      AppData.baseUrl + Endpoints.getDetailCTS(idCTS),
      options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
    );
    return ApiResponse<DetailCtsModel>(
      data: response.data['data'] == null
          ? null
          : DetailCtsModel.fromJson(response.data['data']),
      code: response.statusCode,
      message: response.data['message'],
      traceId: response.data['traceId'],
    );
  }

  static Future<CheckSignatureResponse> checkSignature(
      {required String? idDoc}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.checkSignature,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}),
        data: {"documentId": idDoc});
    return CheckSignatureResponse.fromJson(response.data);
  }
}
