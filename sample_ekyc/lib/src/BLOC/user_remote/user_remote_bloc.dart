import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdsaison_signing/src/BLOC/user_remote/models/response/manager_device_response.dart';

import '../../UI/common_widgets/dialogs/show_dialog_animations.dart';
import '../../base_model/api_response.dart';
import '../../constants/hard_constants.dart';
import '../../constants/http_status_codes.dart';
import '../../helpers/pdf_view_helper.dart';
import '../../navigations/app_pages.dart';
import '../../navigations/app_routes.dart';
import '../../repositories/local/user_local_repository.dart';
import '../../repositories/remote/user_remote_repository.dart';
import '../app_blocs.dart';
import '../timer/timer_bloc.dart';
import 'models/check_signature_response/check_signature_response.dart';
import 'models/forms/esign_confirm_signing_form.dart';
import 'models/response/contract_detail_response.dart';
import 'models/response/contract_item_response.dart';
import 'models/response/contract_status_response.dart';
import 'models/response/detail_cts_model.dart';
import 'models/response/digital_certificate_response.dart';
import 'models/response/esign_confirm_signed_efile.dart';
import 'models/response/esign_request_signing_response.dart';
import 'models/response/notification_data.dart';
import 'models/response/user_infor_response.dart';

part 'user_remote_event.dart';

part 'user_remote_state.dart';

class UserRemoteBloc extends Bloc<UserRemoteEvent, UserRemoteState> {
  UserResponseDataEntry userResponseDataEntry = UserResponseDataEntry.empty;

  List<DeviceDataEntry> deviceDataEntrys = [];
  List<StatusContract> statusContract = [];
  List<NotificationData> notifications = [];
  List<DigitalCertificate> digitalCertificates = [];
  ContractResponseData contractResponseData = ContractResponseData.empty;
  ContractDetailResponse contractDetailResponse = ContractDetailResponse.empty;

  File? PDFFiles;
  File? PDFFilesEForm;
  File? PDFFilesEFormCTS;

  String cachedBase64 = '';
  ESignRequestSigningResponseData? cachedRequestSigningResponse;
  DetailCtsModel detailCtsModel = DetailCtsModel.empty;
  CheckSignatureResponse checkSignatureResponse = CheckSignatureResponse.empty;

  UserRemoteBloc() : super(UserRemoteInitial()) {
    on<UserRemoteGetUserDataEvent>(_onGetUserData);
    on<UserRemoteGetPDFEvent>(_onGetPDF);
    on<UserRemoteGetPDFeFormEvent>(_onGetPDFeForm);
    on<UserRemoteGetPDFeFormCTSEvent>(_onGetPDFeFormCTS);
    on<UserRemoteGetListDeviceEvent>(_onGetListDevice);
    on<UserRemoteGetListNotificationEvent>(_onGetListNotification);
    on<UserRemoteReadNotificationEvent>(_onReadNotification);
    on<UserRemoteGetCancelDeviceEvent>(_onGetCancelDevice);
    on<UserRemoteGetListStatusContractEvent>(_onGetListStatusContract);
    on<UserRemoteGetListDigitalCertificateEvent>(_onGetListDigitalCertificate);
    on<UserRemoteGetListContractsEvent>(_onGetListContracts);
    on<UserRemoteGetDetailContractsEvent>(_onGetDetailContracts);
    on<UserRemoteSaveBase64Event>(_onSaveBase64);
    on<UserRemoteRequestSigningEvent>(_onRequestSigning);
    on<UserRemoteSigningEFormEvent>(_onSigningEForm);
    on<UserRemoteConfirmSigningEvent>(_onConfirmSigning);
    on<UserRemoteCleanDataEvent>(_onCleanData);
    on<UserRemoteRefuseSignEvent>(_onRefuseSign);
    on<UserRemoteUpdateProfileEvent>(_onUpdateProfile);
    on<UserRemoteGetDetailCTSEvent>(_onGetDetailCTS);
    on<UserRemoteCheckSignatureEvent>(_onCheckSignature);
  }

  void _onGetUserData(
    UserRemoteGetUserDataEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _getUserInfor();
    if (userResponseDataEntry != UserResponseDataEntry.empty) {
      emit(_userRemoteGetDoneUserData);
    }
  }

  void _onGetPDF(
    UserRemoteGetPDFEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    final _result = await _getPDFFile(event.PDFLink);
    if (_result) {
      // AppNavigator.push(Routes.ASSETS_PDF_VIEW);
      emit(_userRemoteGetDoneUserData);
    }
  }

  void _onGetPDFeForm(
    UserRemoteGetPDFeFormEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    final _result = await _getPDFFileEform(event.PDFLink);
    if (_result) {
      // AppNavigator.push(Routes.ASSETS_PDF_VIEW);
      emit(_userRemoteGetDoneUserData);
    }
  }

  void _onGetPDFeFormCTS(
    UserRemoteGetPDFeFormCTSEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    final _result = await _getPDFFileEformCTS(event.PDFLink);
    if (_result) {
      emit(_userRemoteGetDoneUserData);
    }
  }

  void _onGetListDevice(
    UserRemoteGetListDeviceEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _getListDevices();
    emit(_userRemoteGetDoneUserData);
  }

  void _onGetListNotification(
    UserRemoteGetListNotificationEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _getListNotifications();
    emit(_userRemoteGetDoneUserData);
  }

  void _onReadNotification(
    UserRemoteReadNotificationEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    await _readNotification(notificationId: event.notificationId);
    add(UserRemoteGetListNotificationEvent());
  }

  void _onGetCancelDevice(
    UserRemoteGetCancelDeviceEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _cancelDevice(deviceId: event.deviceId);
    await _getListDevices();
    emit(_userRemoteGetDoneUserData);
  }

  void _onGetListStatusContract(
    UserRemoteGetListStatusContractEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _getListStatusContract();
    emit(_userRemoteGetDoneUserData);
  }

  void _onGetListDigitalCertificate(
    UserRemoteGetListDigitalCertificateEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _getListDigitalCertificate(event.status);
    emit(_userRemoteGetDoneUserData);
  }

  void _onGetListContracts(
    UserRemoteGetListContractsEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _getListContract(
        type: event.type,
        pageSize: event.pageSize,
        pageNumber: event.pageNumber);
    emit(_userRemoteGetDoneUserData);
  }

  void _onGetDetailContracts(
    UserRemoteGetDetailContractsEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    contractResponseData = ContractResponseData.empty;
    PDFFiles = null;
    PDFFilesEForm = null;
    showDialogLoading();
    emit(_userRemoteLoading);
    await _getDetailContract(idDocument: event.idDocument);
    emit(_userRemoteGetDoneUserData);
    await Future.delayed(DELAY_250_MS * 2.5);
    AppNavigator.pop();
  }

  void _onSaveBase64(
    UserRemoteSaveBase64Event event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    _saveBase64(event.signatureBase64);
    emit(_userRemoteGetDoneUserData);
  }

  void _onRequestSigning(
    UserRemoteRequestSigningEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    if (await _yeuCauKyHoSo()) {
      AppBlocs.timerBloc.add(
        StartCountdownSmartOtpTimerEvent(
          maxDuration: 60,
          onTimerFinish: () => AppBlocs.userRemoteBloc.add(
            UserRemoteRequestSigningEvent(),
          ),
        ),
      );
      emit(_userRemoteGetDoneUserData);
    } else {
      showToast(ToastType.error, title: 'Lấy OTP thất bại');
    }
  }

  void _onSigningEForm(
    UserRemoteSigningEFormEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    await _kyEForm();
    emit(_userRemoteGetDoneUserData);
  }

  void _onConfirmSigning(
    UserRemoteConfirmSigningEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    emit(_userRemoteLoading);
    if (await _xacNhanKyHoSo(event.signType, event.idCts)) {
      emit(_userRemoteGetDoneUserData);
    }
  }

  void _onCleanData(
    UserRemoteCleanDataEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    _cleanUserRemoteData();
    emit(UserRemoteInitial());
  }

  void _onRefuseSign(
    UserRemoteRefuseSignEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    if (await _refuseSign(event)) {
      add(UserRemoteGetDetailContractsEvent(idDocument: event.documentId));
    } else {
      showToast(ToastType.error, title: 'Từ chối ký thất bại');
    }
  }

  void _onUpdateProfile(
    UserRemoteUpdateProfileEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    if (await _updateProfile(event)) {
      add(UserRemoteGetUserDataEvent());
    } else {
      showToast(ToastType.error, title: 'Cập nhật thông tin thất bại');
    }
  }

  void _onGetDetailCTS(
    UserRemoteGetDetailCTSEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    detailCtsModel = DetailCtsModel.empty;
    emit(_userRemoteLoading);
    final res = await _getDetailCTS(event);
    if (res.code == 200) {
      detailCtsModel = res.data!;
    } else {
      showToast(ToastType.error, title: res.message);
    }
    emit(_userRemoteGetDoneUserData);
  }

  void _onCheckSignature(
    UserRemoteCheckSignatureEvent event,
    Emitter<UserRemoteState> emit,
  ) async {
    showDialogLoading();
    checkSignatureResponse = CheckSignatureResponse.empty;
    final res = await UserRemoteRepo.checkSignature(idDoc: event.idDoc);
    if (res.code == 200) {
      checkSignatureResponse = res;
      AppNavigator.pop();
      AppNavigator.push(Routes.CHECK_SIGNATURE);
    } else {
      AppNavigator.pop();
      showToast(ToastType.error, title: res.message);
    }
    emit(_userRemoteGetDoneUserData);
  }

  //*-----------------------------------------------------------------------

  // STATE

  UserRemoteLoading get _userRemoteLoading => UserRemoteLoading(
        userResponseDataEntry: userResponseDataEntry,
        statusContract: statusContract,
        notifications: notifications,
        digitalCertificates: digitalCertificates,
        listDevices: deviceDataEntrys,
        contractResponseData: contractResponseData,
        contractDetailResponse: contractDetailResponse,
        PDFFiles: PDFFiles,
        PDFFilesEForm: PDFFilesEForm,
        PDFFilesEFormCTS: PDFFilesEFormCTS,
        detailCtsModel: detailCtsModel,
        checkSignatureResponse: checkSignatureResponse,
      );

  UserRemoteGetDoneData get _userRemoteGetDoneUserData => UserRemoteGetDoneData(
        userResponseDataEntry: userResponseDataEntry,
        contractResponseData: contractResponseData,
        statusContract: statusContract,
        notifications: notifications,
        listDevices: deviceDataEntrys,
        digitalCertificates: digitalCertificates,
        contractDetailResponse: contractDetailResponse,
        PDFFiles: PDFFiles,
        PDFFilesEForm: PDFFilesEForm,
        PDFFilesEFormCTS: PDFFilesEFormCTS,
        detailCtsModel: detailCtsModel,
        checkSignatureResponse: checkSignatureResponse,
      );

  // MARK: PRIVATE METHOD

  Future<void> _getUserInfor() async {
    final UserInforResponse? response = await UserRemoteRepo.getUserProfile();
    if (response?.data != null) {
      userResponseDataEntry = response!.data!;
      if (AppBlocs.authenticationBloc.rememberAccount == true) {
        UserLocalRepository().saveName(
            username: AppBlocs.authenticationBloc.cachedUsername,
            name: (userResponseDataEntry.name ?? 'Bác Sĩ'));
      }
    }
  }

  Future<bool> _getPDFFile(String url) async {
    final File? _file = await PDFHelper().createFileOfPdfUrl(url: url);
    if (_file != null) {
      PDFFiles = _file;
      // await Future.delayed(DELAY_500_MS * 1);
      return true;
    }
    return false;
  }

  Future<bool> _getPDFFileEform(String url) async {
    final File? _file = await PDFHelper().createFileOfPdfUrl(url: url);
    if (_file != null) {
      PDFFilesEForm = _file;
      // await Future.delayed(DELAY_500_MS * 1);
      return true;
    }
    return false;
  }

  Future<bool> _getPDFFileEformCTS(String url) async {
    final File? _file = await PDFHelper().createFileOfPdfUrl(url: url);
    if (_file != null) {
      PDFFilesEFormCTS = _file;
      return true;
    }
    return false;
  }

  Future<void> _getListDevices() async {
    final ManagerDeviceResponse? response =
        await UserRemoteRepo.getListDevices();
    if (response?.data != null && response?.code == 200) {
      deviceDataEntrys = response!.data!;
    }
    return;
  }

  Future<void> _getListNotifications() async {
    final List<NotificationData> response =
        await UserRemoteRepo.getListNotification() ?? [];

    notifications = response;

    return;
  }

  Future<bool> _readNotification({required String notificationId}) async {
    showDialogLoading();
    final bool result =
        await UserRemoteRepo.readNotification(notificationId: notificationId);
    if (result) {
      AppNavigator.pop();
      return true;
    } else {
      AppNavigator.pop();
      return false;
    }
  }

  Future<void> _getListStatusContract() async {
    final ContractStatusResponse? response =
        await UserRemoteRepo.getListStatusContract();
    if (response?.data != null && response?.code == 200) {
      statusContract = response!.data!;
    }
    return;
  }

  Future<void> _getListDigitalCertificate([bool? status]) async {
    final DigitalCertificateResponse? response =
        await UserRemoteRepo.getListDigitalCertificate(status);
    if (response?.data != null && response?.code == 200) {
      digitalCertificates = response!.data!;
    }
    return;
  }

  Future<void> _getListContract(
      {required int type,
      required int pageSize,
      required int pageNumber}) async {
    final ContractResponseData? response = await UserRemoteRepo.getListContract(
        pageNumbe: pageNumber, pageSize: pageSize, type: type);
    if (response?.data != null) {
      contractResponseData = response!;
    }
    return;
  }

  Future<void> _getDetailContract({required String idDocument}) async {
    final ContractDetailResponse? response =
        await UserRemoteRepo.getDetailContract(idDocument: idDocument);
    if (response != null && response.code == StatusCode.OK) {
      contractDetailResponse = response;
      AppBlocs.userRemoteBloc.add(UserRemoteGetPDFEvent(
          PDFLink: contractDetailResponse.data?.filePreviewUrl ?? ''));
      AppBlocs.userRemoteBloc.add(UserRemoteGetPDFeFormEvent(
          PDFLink: contractDetailResponse.data?.eForm?.fileUrl ?? ''));
    }
    return;
  }

  Future<bool> _kyEForm() async {
    showDialogLoading();
    final ESignRequestSigningResponse? response =
        await UserRemoteRepo.signEForm(
            userConnectId: '',
            documentId: contractDetailResponse.data!.eForm?.eFormId ?? '',
            documentCode: contractDetailResponse.data!.eForm?.eFormCode ?? '',
            signatureBase64: '');
    if (response?.data != null && response?.code == 200) {
      AppNavigator.pop();
      AppNavigator.push(Routes.DRAW_SIGNATURE);
      return true;
    } else {
      AppNavigator.pop();
      return false;
    }
  }

  Future<bool> _yeuCauKyHoSo() async {
    showDialogLoading();
    final ESignRequestSigningResponse? response =
        await UserRemoteRepo.requestSignEFile(
            userConnectId: '',
            documentCode: contractDetailResponse.data!.documentCode!,
            documentId: contractDetailResponse.data!.documentId!,
            signatureBase64: cachedBase64);
    if (response?.data != null) {
      cachedRequestSigningResponse = response?.data;
      AppNavigator.pop();
      return true;
    } else {
      AppNavigator.pop();
      return false;
    }
  }

  Future<bool> _cancelDevice({required String deviceId}) async {
    showDialogLoading();
    final bool result = await UserRemoteRepo.cancelDevice(deviceId: deviceId);
    if (result) {
      AppNavigator.pop();
      return true;
    } else {
      AppNavigator.pop();
      return false;
    }
  }

  Future<bool> _xacNhanKyHoSo(bool signType, String idHSM) async {
    showDialogLoading();
    final Map<dynamic, dynamic> deviceInfor =
        await UserLocalRepository().getDeviceInfor();
    final String deviceId = deviceInfor["device_id"];
    final ConfirmSigningEFileForm form = ConfirmSigningEFileForm(
        requestId: AppBlocs.notificationBloc.cachedOTPModel?.requestId ?? '',
        sadRequestId:
            AppBlocs.notificationBloc.cachedOTPModel?.sadRequestId ?? '',
        deviceId: deviceId,
        documentId:
            AppBlocs.userRemoteBloc.contractDetailResponse.data?.documentId ??
                '',
        userId: AppBlocs.userRemoteBloc.userResponseDataEntry.id ?? '',
        // organization: "Savis",
        // organizationUnit: "HDSaison",
        otp: AppBlocs.notificationBloc.cachedOTPModel?.otp ?? '',
        signType: signType,
        idHSM: signType == false ? idHSM : null,

        /// true là ký điện tử an toàn - false là kí CTS
        jwt: AppBlocs.notificationBloc.cachedOTPModel?.jwt ?? "");
    final ConfirmSigningEFileResponse? response =
        await UserRemoteRepo.confirmSignEFile(
      form: form,
      // documentCode: cachedEcontractItem!.entry!.documentCode!
    );

    if (response?.code != 200) {
      AppNavigator.pop();
      showToast(ToastType.error, title: response?.message ?? '');
      return false;
    }

    if (response?.data != null) {
      AppBlocs.userRemoteBloc
          .add(UserRemoteGetDetailContractsEvent(idDocument: form.documentId));

      /// reload lại chi tiết hợp đồng
      AppBlocs.userRemoteBloc.add(UserRemoteGetListContractsEvent(
          type: 1, pageSize: 20, pageNumber: 1));

      /// reload lại danh sách hợp đồng
      AppBlocs.userRemoteBloc.add(UserRemoteGetListStatusContractEvent());

      /// reload lại số đếm hợp đồng
      // AppBlocs.userRemoteBloc.add(UserRemoteGetDetailContractsEvent(idDocument: widget.idDocument));

      AppNavigator.pop();
      AppNavigator.replaceWith(Routes.COMPLETE_SIGN_CONTRACT);

      AppBlocs.timerBloc.add(StopCountdownSmartOtpTimerEvent());
      return true;
    } else {
      AppNavigator.pop();
      showToast(ToastType.error, title: response?.message ?? '');
      return false;
    }
  }

  // void _saveBase64(String base64) {
  //   cachedBase64 = base64;
  //   AppNavigator.push(Routes.MEDICAL_RECORD_PINCODE);
  // }

  void _saveBase64(String base64) {
    cachedBase64 = base64;
  }

  Future<bool> _updateProfile(UserRemoteUpdateProfileEvent event) async {
    final resopnse =
        await UserRemoteRepo.updateProfile(userInfo: event.userInfo);
    return resopnse;
  }

  void _cleanUserRemoteData() {
    userResponseDataEntry = UserResponseDataEntry.empty;
    statusContract = [];
    digitalCertificates = [];
    PDFFiles = null;
    PDFFilesEForm = null;
    cachedBase64 = '';
    cachedRequestSigningResponse = null;
  }

  Future<bool> _refuseSign(UserRemoteRefuseSignEvent event) async {
    final resopnse = await UserRemoteRepo.refuseSign(
        documentId: event.documentId, reason: event.rejectReason);
    return resopnse;
  }

  Future<ApiResponse<DetailCtsModel>> _getDetailCTS(
      UserRemoteGetDetailCTSEvent event) async {
    final resopnse = await UserRemoteRepo.getDetailCTS(idCTS: event.idCTS);
    return resopnse;
  }
}
