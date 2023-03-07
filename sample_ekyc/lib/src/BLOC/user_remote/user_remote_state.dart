part of 'user_remote_bloc.dart';

abstract class UserRemoteState {}

class UserRemoteInitial extends UserRemoteState {}

class UserRemoteLoading extends UserRemoteState {
  final UserResponseDataEntry userResponseDataEntry;
  final ContractResponseData contractResponseData;
  final List<StatusContract> statusContract;
  final List<NotificationData> notifications;
  final List<DeviceDataEntry> listDevices;
  final List<DigitalCertificate> digitalCertificates;
  final ContractDetailResponse contractDetailResponse;
  final File? PDFFiles;
  final File? PDFFilesEForm;
  final File? PDFFilesEFormCTS;
  final DetailCtsModel? detailCtsModel;
  final CheckSignatureResponse? checkSignatureResponse;
  UserRemoteLoading({
    required this.userResponseDataEntry,
    required this.contractResponseData,
    required this.statusContract,
    required this.notifications,
    required this.listDevices,
    required this.digitalCertificates,
    required this.contractDetailResponse,
    required this.PDFFiles,
    required this.PDFFilesEForm,
    required this.PDFFilesEFormCTS,
    required this.detailCtsModel,
    required this.checkSignatureResponse,
  });
}

class UserRemoteGetDoneData extends UserRemoteState {
  final UserResponseDataEntry userResponseDataEntry;
  final List<StatusContract> statusContract;
  final List<NotificationData> notifications;
  final List<DeviceDataEntry> listDevices;
  final List<DigitalCertificate> digitalCertificates;
  final ContractResponseData contractResponseData;
  final ContractDetailResponse contractDetailResponse;
  final File? PDFFiles;
  final File? PDFFilesEForm;
  final File? PDFFilesEFormCTS;
  final DetailCtsModel? detailCtsModel;
  final CheckSignatureResponse? checkSignatureResponse;

  UserRemoteGetDoneData({
    required this.userResponseDataEntry,
    required this.contractResponseData,
    required this.listDevices,
    required this.notifications,
    required this.statusContract,
    required this.digitalCertificates,
    required this.contractDetailResponse,
    required this.PDFFiles,
    required this.PDFFilesEForm,
    required this.PDFFilesEFormCTS,
    required this.detailCtsModel,
    required this.checkSignatureResponse,
  });
}

class UserRemote extends UserRemoteState {}
