import 'dart:async';

import 'package:sample_sdk_flutter/src/utils/api_utils/card_back_response_handler/card_back_response.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/card_front_response_handler/card_front_response.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/face_video_response_handler/face_video_response.dart';
import 'package:sample_sdk_flutter/src/utils/api_utils/init_session_response_handler/init_session_response.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:sample_sdk_flutter/src/utils/app_config.dart';

class ApiHelper {
  static CardFrontResponseModel? cardFrontResponseModel;
  static CardBackResponseModel? cardBackResponseModel;
  static FaceVideoResponse? faceVideoResponse;
  static String? frontCardImagePath;
  static String? backCardImagePath;
  static String apiUrl = AppConfig().apiUrl;
  static int timeOut = 20;

  static Future<InitResponseHandler> initEkycSession() async {
    var url = Uri.parse('$apiUrl/start_session/');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'token ${AppConfig().token}';
    request.fields['source'] = AppConfig().source;

    print("AppConfig().deviceInfor = ");
    print(AppConfig().deviceInfor);
    request.fields['meta'] = json.encode(
      AppConfig().deviceInfor.toMap(),
    );
    request.fields['email'] = AppConfig().email;
    request.fields['phone'] = AppConfig().phone;
    InitResponseHandler initResponseHandler = InitResponseHandler();
    try {
      var streamResponse =
          await request.send().timeout(Duration(seconds: timeOut));
      var response = await http.Response.fromStream(streamResponse);
      if (response.statusCode == 200) {
        initResponseHandler = InitResponseHandler.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        AppConfig().eKycSessionInfor.setInitResponseResult(initResponseHandler);
      }
    } on TimeoutException catch (e) {
      initResponseHandler.code = "TIMEOUT";
      initResponseHandler.error = "timeout";
      print(e);
    } catch (e) {
      print(e);
    }
    return initResponseHandler;
  }

  static Future<CardFrontResponseModel> uploadCardFront(
      String cardFront) async {
    print(">>>>>>>>>>>>>>>>>>>> uploadCardFront");

    var url = Uri.parse('https://sandbox-apim.savis.vn/ekyc-fpt/v1/api/register_user_card/');
    File cardFrontFile = File(cardFront);
    var request = http.MultipartRequest('POST', url);
    // request.headers['Authorization'] = 'token ${AppConfig().token}';
    request.headers['apikey'] = 'eyJ4NXQiOiJOVGRtWmpNNFpEazNOalkwWXpjNU1tWm1PRGd3TVRFM01XWXdOREU1TVdSbFpEZzROemM0WkE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhcHBsaWNhdGlvbiI6eyJvd25lciI6ImFkbWluIiwidGllclF1b3RhVHlwZSI6bnVsbCwidGllciI6IjUwUGVyTWluIiwibmFtZSI6ImVLeWMtRlBUIiwiaWQiOjkzLCJ1dWlkIjoiNDQ0ODFmZjQtZjhjMC00ZjIyLTg0MzQtYWNiNDIwMDc0ZjgyIn0sImlzcyI6Imh0dHBzOlwvXC8xMC4wLjIwLjEwNDo5NDQ0XC9vYXV0aDJcL3Rva2VuIiwidGllckluZm8iOnsiQnJvbnplIjp7InRpZXJRdW90YVR5cGUiOiJyZXF1ZXN0Q291bnQiLCJncmFwaFFMTWF4Q29tcGxleGl0eSI6MCwiZ3JhcGhRTE1heERlcHRoIjowLCJzdG9wT25RdW90YVJlYWNoIjp0cnVlLCJzcGlrZUFycmVzdExpbWl0IjowLCJzcGlrZUFycmVzdFVuaXQiOm51bGx9fSwia2V5dHlwZSI6IlBST0RVQ1RJT04iLCJwZXJtaXR0ZWRSZWZlcmVyIjoiIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiZUtZQ19EZXZfdGVzdF9GUFQiLCJjb250ZXh0IjoiXC9la3ljLWZwdFwvdjEiLCJwdWJsaXNoZXIiOiJhZG1pbiIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJCcm9uemUifV0sInBlcm1pdHRlZElQIjoiIiwiaWF0IjoxNjU0MzE2NjExLCJqdGkiOiI4Mjk0MmQ5Yi1lNWU4LTQwYWItYTU0YS0wOTNjZGQwNTAxZjgifQ==.MzUzSt1CPGnIGJaxQsMVmdb6TnVbvNIreRmhnwvh-55UwAem-Z1uwS7Jp-syPsDWHIpZ7J-c5Il5fvxAMjP8iKpnDMLl2lis4gi2sSu9maYdp3NaNS9ahwpfVjM_WMm0inH60ZOfPkM5-RVo381BYFtVkhh2BWZxR0Dsw-P5qgNRafSjRliEH143iwIG012Uz69fQOJTxT-bT1UXYqh7lhL2jCrFgnTHgcUyYEKyvbE9AXKqHSr7JQVs9vU5CXoPoxku2oiNLG7VLwEzcXj5W8ukmZ8ADU8ITjRVWyJWFEv1LxEgin5-8jQNtMAqIued9_p9jcpiPTf_IhQ4iZCmGA==';

    request.fields['session_id'] = AppConfig().eKycSessionInfor.sessionId;
    request.fields['type'] = 'FR';
    request.fields['check_liveness'] = 'True';
    request.fields['force_register'] = 'False';
    request.fields['exclude'] = 'embedding,created';
    request.fields['source'] = AppConfig().source;
    request.fields['force_replace'] = 'False';
    Map<String, String> meta = AppConfig().deviceInfor.toMap();
    meta['fileSize'] = cardFrontFile.lengthSync().toString();
    request.fields['meta'] = json.encode(meta);
    request.fields['email'] = AppConfig().email;
    request.fields['phone'] = AppConfig().phone;
    request.files.add(
      http.MultipartFile.fromBytes('image', cardFrontFile.readAsBytesSync(),
          filename: 'photo1.png'),
    );

    CardFrontResponseModel newResponse = CardFrontResponseModel();

      var streamResponse =
          await request.send().timeout(Duration(seconds: timeOut));
      var response = await http.Response.fromStream(streamResponse);
    print(">>>>>>>>>>>>>> ${response.body}");

    if (response.statusCode == 200) {
        newResponse = CardFrontResponseModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        frontCardImagePath = cardFront;
        cardFrontResponseModel = newResponse;
        AppConfig().eKycSessionInfor.setCardFrontResponseResult(newResponse);
      } else {
        print('Failed to upload card front');
      }
      AppConfig().eKycSessionInfor.setCardFrontImagePath(cardFront);

    return newResponse;
  }

  static Future<CardBackResponseModel> uploadCardBack(String cardBack) async {
    print(">>>>>>>>>>>>>>>>>>>> uploadCardBack");
    var url = Uri.parse('https://sandbox-apim.savis.vn/ekyc-fpt/v1/api/register_user_card/');
    var request = http.MultipartRequest('POST', url);
    File cardBackFile = File(cardBack);
    // request.headers['Authorization'] = 'token ${AppConfig().token}';
    request.headers['apikey'] = 'eyJ4NXQiOiJOVGRtWmpNNFpEazNOalkwWXpjNU1tWm1PRGd3TVRFM01XWXdOREU1TVdSbFpEZzROemM0WkE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhcHBsaWNhdGlvbiI6eyJvd25lciI6ImFkbWluIiwidGllclF1b3RhVHlwZSI6bnVsbCwidGllciI6IjUwUGVyTWluIiwibmFtZSI6ImVLeWMtRlBUIiwiaWQiOjkzLCJ1dWlkIjoiNDQ0ODFmZjQtZjhjMC00ZjIyLTg0MzQtYWNiNDIwMDc0ZjgyIn0sImlzcyI6Imh0dHBzOlwvXC8xMC4wLjIwLjEwNDo5NDQ0XC9vYXV0aDJcL3Rva2VuIiwidGllckluZm8iOnsiQnJvbnplIjp7InRpZXJRdW90YVR5cGUiOiJyZXF1ZXN0Q291bnQiLCJncmFwaFFMTWF4Q29tcGxleGl0eSI6MCwiZ3JhcGhRTE1heERlcHRoIjowLCJzdG9wT25RdW90YVJlYWNoIjp0cnVlLCJzcGlrZUFycmVzdExpbWl0IjowLCJzcGlrZUFycmVzdFVuaXQiOm51bGx9fSwia2V5dHlwZSI6IlBST0RVQ1RJT04iLCJwZXJtaXR0ZWRSZWZlcmVyIjoiIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiZUtZQ19EZXZfdGVzdF9GUFQiLCJjb250ZXh0IjoiXC9la3ljLWZwdFwvdjEiLCJwdWJsaXNoZXIiOiJhZG1pbiIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJCcm9uemUifV0sInBlcm1pdHRlZElQIjoiIiwiaWF0IjoxNjU0MzE2NjExLCJqdGkiOiI4Mjk0MmQ5Yi1lNWU4LTQwYWItYTU0YS0wOTNjZGQwNTAxZjgifQ==.MzUzSt1CPGnIGJaxQsMVmdb6TnVbvNIreRmhnwvh-55UwAem-Z1uwS7Jp-syPsDWHIpZ7J-c5Il5fvxAMjP8iKpnDMLl2lis4gi2sSu9maYdp3NaNS9ahwpfVjM_WMm0inH60ZOfPkM5-RVo381BYFtVkhh2BWZxR0Dsw-P5qgNRafSjRliEH143iwIG012Uz69fQOJTxT-bT1UXYqh7lhL2jCrFgnTHgcUyYEKyvbE9AXKqHSr7JQVs9vU5CXoPoxku2oiNLG7VLwEzcXj5W8ukmZ8ADU8ITjRVWyJWFEv1LxEgin5-8jQNtMAqIued9_p9jcpiPTf_IhQ4iZCmGA==';

    request.fields['session_id'] = AppConfig().eKycSessionInfor.sessionId;
    request.fields['type'] = 'BA';
    request.fields['check_liveness'] = 'True';
    request.fields['force_register'] = 'False';
    request.fields['exclude'] = 'embedding,created';
    request.fields['source'] = AppConfig().source;
    request.fields['force_replace'] = 'True';
    Map<String, String> meta = AppConfig().deviceInfor.toMap();
    meta['fileSize'] = cardBackFile.lengthSync().toString();
    request.fields['meta'] = json.encode(meta);
    request.fields['email'] = AppConfig().email;
    request.fields['phone'] = AppConfig().phone;
    request.files.add(
      http.MultipartFile.fromBytes('image', cardBackFile.readAsBytesSync(),
          filename: 'photo1.png'),
    );

    CardBackResponseModel newResponse = CardBackResponseModel();
    try {
      var streamResponse =
          await request.send().timeout(Duration(seconds: timeOut));
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        newResponse = CardBackResponseModel.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        backCardImagePath = cardBack;
        cardBackResponseModel = newResponse;
        AppConfig().eKycSessionInfor.setCardBackResponseResult(newResponse);
      } else {
        print('Failed to upload card back');
      }
    } on TimeoutException catch (e) {
      newResponse.code = "TIMEOUT";
      newResponse.error = "timeout";
      print(e);
    } catch (e) {
      print(e);
    }
    AppConfig().eKycSessionInfor.setCardBackImagePath(cardBack);
    return newResponse;
  }

  static Future<FaceVideoResponse> uploadFaceVideo(String videoPath) async {
    var url = Uri.parse('https://sandbox-apim.savis.vn/ekyc-fpt/v1/api/register_user_video/');
    var request = http.MultipartRequest('POST', url);
    File videoFile = File(videoPath);
    // request.headers['Authorization'] = 'token ${AppConfig().token}';
    request.headers['apikey'] = 'eyJ4NXQiOiJOVGRtWmpNNFpEazNOalkwWXpjNU1tWm1PRGd3TVRFM01XWXdOREU1TVdSbFpEZzROemM0WkE9PSIsImtpZCI6ImdhdGV3YXlfY2VydGlmaWNhdGVfYWxpYXMiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbkBjYXJib24uc3VwZXIiLCJhcHBsaWNhdGlvbiI6eyJvd25lciI6ImFkbWluIiwidGllclF1b3RhVHlwZSI6bnVsbCwidGllciI6IjUwUGVyTWluIiwibmFtZSI6ImVLeWMtRlBUIiwiaWQiOjkzLCJ1dWlkIjoiNDQ0ODFmZjQtZjhjMC00ZjIyLTg0MzQtYWNiNDIwMDc0ZjgyIn0sImlzcyI6Imh0dHBzOlwvXC8xMC4wLjIwLjEwNDo5NDQ0XC9vYXV0aDJcL3Rva2VuIiwidGllckluZm8iOnsiQnJvbnplIjp7InRpZXJRdW90YVR5cGUiOiJyZXF1ZXN0Q291bnQiLCJncmFwaFFMTWF4Q29tcGxleGl0eSI6MCwiZ3JhcGhRTE1heERlcHRoIjowLCJzdG9wT25RdW90YVJlYWNoIjp0cnVlLCJzcGlrZUFycmVzdExpbWl0IjowLCJzcGlrZUFycmVzdFVuaXQiOm51bGx9fSwia2V5dHlwZSI6IlBST0RVQ1RJT04iLCJwZXJtaXR0ZWRSZWZlcmVyIjoiIiwic3Vic2NyaWJlZEFQSXMiOlt7InN1YnNjcmliZXJUZW5hbnREb21haW4iOiJjYXJib24uc3VwZXIiLCJuYW1lIjoiZUtZQ19EZXZfdGVzdF9GUFQiLCJjb250ZXh0IjoiXC9la3ljLWZwdFwvdjEiLCJwdWJsaXNoZXIiOiJhZG1pbiIsInZlcnNpb24iOiJ2MSIsInN1YnNjcmlwdGlvblRpZXIiOiJCcm9uemUifV0sInBlcm1pdHRlZElQIjoiIiwiaWF0IjoxNjU0MzE2NjExLCJqdGkiOiI4Mjk0MmQ5Yi1lNWU4LTQwYWItYTU0YS0wOTNjZGQwNTAxZjgifQ==.MzUzSt1CPGnIGJaxQsMVmdb6TnVbvNIreRmhnwvh-55UwAem-Z1uwS7Jp-syPsDWHIpZ7J-c5Il5fvxAMjP8iKpnDMLl2lis4gi2sSu9maYdp3NaNS9ahwpfVjM_WMm0inH60ZOfPkM5-RVo381BYFtVkhh2BWZxR0Dsw-P5qgNRafSjRliEH143iwIG012Uz69fQOJTxT-bT1UXYqh7lhL2jCrFgnTHgcUyYEKyvbE9AXKqHSr7JQVs9vU5CXoPoxku2oiNLG7VLwEzcXj5W8ukmZ8ADU8ITjRVWyJWFEv1LxEgin5-8jQNtMAqIued9_p9jcpiPTf_IhQ4iZCmGA==';

    request.fields['session_id'] = AppConfig().eKycSessionInfor.sessionId;
    request.fields['check_liveness'] = 'True';
    request.fields['force_register'] = 'False';
    request.fields['exclude'] = 'embedding,created';
    request.fields['source'] = AppConfig().source;
    request.fields['force_replace'] = 'True';
    request.fields['threshold'] = '0.8';
    Map<String, String> meta = AppConfig().deviceInfor.toMap();
    meta['fileSize'] = videoFile.lengthSync().toString();
    request.fields['meta'] = json.encode(meta);
    request.fields['email'] = AppConfig().email;
    request.fields['phone'] = AppConfig().phone;
    request.files.add(
      http.MultipartFile.fromBytes('video', videoFile.readAsBytesSync(),
          filename: 'liveness_video.mp4'),
    );
    FaceVideoResponse newResponse = FaceVideoResponse();
try{
      var streamResponse =
          await request.send().timeout(Duration(seconds: 3 * timeOut));
      var response = await http.Response.fromStream(streamResponse);

      if (response.statusCode == 200) {
        newResponse = FaceVideoResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes)));
        faceVideoResponse = newResponse;
        print(">>>>>>>>>>>>>>>>>>>>> ${response.body}");
        AppConfig().eKycSessionInfor.setFaceVideoResponseResult(newResponse);
      } else {
        print('Failed to upload face video');
      }
    } on TimeoutException catch (e) {
      newResponse.code = "TIMEOUT";
      newResponse.error = "timeout";
      print(e);
    } catch (e) {
      print(e);
    }
    return newResponse;
  }
}
