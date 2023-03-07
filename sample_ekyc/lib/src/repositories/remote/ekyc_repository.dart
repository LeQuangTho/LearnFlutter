import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:sample_sdk_flutter/src/models/ekyc_session.dart';

import '../../BLOC/app_blocs.dart';
import '../../BLOC/ekyc/ekyc_bloc.dart';
import '../../BLOC/ekyc/models/detail_ocr_response/detail_ocr_response.dart';
import '../../BLOC/ekyc/models/ekyc_eform_response/ekyc_eform_response.dart';
import '../../BLOC/ekyc/models/ekyc_upload_file_response/ekyc_upload_file_response.dart';
import '../../base_model/api_response.dart';
import '../../configs/application.dart';
import '../../constants/endpoints.dart';
import '../../helpers/geolocator_helper.dart';
import '../local/user_local_repository.dart';
import 'base_dio.dart';

class EkycReporitory {
  Future<EkycEformCTSResponse?> createEformRequestDiCer(
      EkycCreateEformRequestDiCerEvent event) async {
    if (await createOrUpdateOCRInfo(event.info!)) {
      AppBlocs.authenticationBloc.loginResponseData.userModel?.setIsEKYC = true;
      final String accessToken = await UserLocalRepository().getAccessToken();
      final deviceInfor = await UserLocalRepository().getDeviceInfor();
      final location = await GeolocatorHelper().getCurrentPosition();
      final data = {
        "certValidTime": event.certValidTime ?? '24H',
        "location": location?.toMap(),
        "deviceInfo": deviceInfor
      };

      final Response response = await BaseDio.instance.dio.post(
          AppData.baseUrl + Endpoints.createEformRequestCertificate,
          data: data,
          options:
              Options(headers: {'Authorization': 'Bearer ' + accessToken}));

      return EkycEformCTSResponse.fromJson(response.data);
    }
    return null;
  }

  Future<bool> createOrUpdateOCRInfo(EKycSessionInfor info) async {
    final String accessToken = await UserLocalRepository().getAccessToken();

    final data = {
      "userId": AppBlocs.userRemoteBloc.userResponseDataEntry.id,
      "fullName": info.name,
      "nation": info.nation,
      "birthday": DateFormat('dd/MM/yyyy')
          .parse(info.dateOfBirth.replaceAll('-', '/'))
          .toIso8601String(),
      "birthPlace": info.placeOfOrigin,
      "sex": info.sex == "None" ? null : (info.sex == "Nam" ? 1 : 0),
      "identityNumber": info.idNumber,
      "issueDate": DateFormat('dd/MM/yyyy')
          .parse(info.dateOfIssue
              .replaceAll("NGÀY", '')
              .replaceAll("THÁNG", '/')
              .replaceAll("NĂM", '/')
              .replaceAll(" ", "")
              .replaceAll('-', '/')
              .toString())
          .toIso8601String(),
      "expireDate": info.dateOfExpiry != "None"
          ? DateFormat('dd/MM/yyyy').parse(info.dateOfExpiry.replaceAll('-', '/')).toIso8601String()
          : null,
      "issueBy": info.issuedAt != "None" ? info.issuedAt : null,
      "ethnic": null,
      "religion": null,
      "placeOfOrigin": info.placeOfOrigin,
      "placeOfResidence": info.placeOfResidence,
      "personalIdentification": null
    };

    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.createOrUpdateOCRInfo,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}));

    print(">>>>>>>>>>>>>>>>>");

    if (response.data['code'] == 200) {
      return true;
    }
    return false;
  }

  Future<EkycEformCTSResponse> confirmEformRequestDiCer(
      EkycConfirmEformRequestDiCerEvent event) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final deviceInfor = await UserLocalRepository().getDeviceInfor();
    final location = await GeolocatorHelper().getCurrentPosition();
    final data = {
      "documentCode": event.documentCode,
      "location": location?.toMap(),
      "deviceInfo": deviceInfor
    };

    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.createEformRequestCertificate,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}));

    return EkycEformCTSResponse.fromJson(response.data);
  }

  Future<ApiResponse<String>> addCTS() async {
    final String accessToken = await UserLocalRepository().getAccessToken();

    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.addCTS,
        data: {},
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}));

    return ApiResponse<String>.fromJson(response.data);
  }

  Future<EkycUploadFileResponse> uploadFile(
      {required File file, required String name}) async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    String fileName = '$name.${file.path.split('/').last.split('.').last}';

    print(">>>>>>>>>>>>>>>>>2 ${file.lengthSync()}");
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final Response response = await BaseDio.instance.dio.post(
        AppData.baseUrl + Endpoints.uploadFile,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}));

    return EkycUploadFileResponse.fromJson(response.data);
  }

  Future<DetailOcrResponse> getDetailOcrInfo() async {
    final String accessToken = await UserLocalRepository().getAccessToken();
    final Response response = await BaseDio.instance.dio.get(
        AppData.baseUrl + Endpoints.getDetailOcrInfo,
        options: Options(headers: {'Authorization': 'Bearer ' + accessToken}));
    return DetailOcrResponse.fromJson(response.data);
  }
}
